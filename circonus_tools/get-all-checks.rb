#!/usr/bin/ruby

require 'json'
require 'rest_client'
require 'circonus'

f = open('./config.json', 'r').read
@j = JSON.parse(f)

# setup client
@circonus = RestClient::Resource.new('https://api.mon.vgtf.net', :headers => {
  :x_circonus_app_name => "#{@j['app']}",
  :x_circonus_auth_token => "#{@j['apitoken']}",
  :accept => :json,
})
# Setup time 
hours = @j['hours'] # Change this in the config.json file
@endtime = Time.now.to_i # get the current time and convert to epoch
@starttime = @endtime - (hours * 60 * 60) # convert hours to seconds and subtract from the current time epoch

puts "%-37s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % %w{ Hostname Customer CPUMeanIdle CPUPeakIdle MemMeanUsed MemPeakUsed DiskMeanUsed DiskPeakUsed }
def data(hostname, customer,  checkid)
  c = Circonus.new('a06a1a30-4249-4ec3-bb0b-e54c890a7f15', 'curl')
  c.set_server('api.mon.vgtf.net')
  
  cpulist = []
  memlist = []
  disklist = []
  begin 
    c.get_data(checkid, @j['cpu'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpulist << line[1]['counter']
    end
    
    c.get_data(checkid, @j['memory'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      memlist << line[1]['value']
    end
    
    c.get_data(checkid, @j['disk'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      disklist << line[1]['value']
    end
    
    puts "%-37s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % [hostname, customer, (cpulist.reduce(&:+) / cpulist.length).round(2).to_s, cpulist.sort![-1].round(2).to_s, ((memlist.reduce(&:+) / memlist.length) / 1024 / 1024 ).round(2).to_s, (memlist.sort![-1] / 1024 / 1024).round(2).to_s, ((disklist.reduce(&:+) / disklist.length) / 1024 / 1024).round(2).to_s, (disklist.sort![-1] / 1024 / 1024).round(2).to_s ]
  rescue 
    puts "%-37s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % [hostname, customer, 'nil', 'nil', 'nil', 'nil', 'nil', 'nil']
  end
end

begin
  hostlist = {} 
  fqdn = ''
  cust = ''
  response = @circonus['/check'].get  
  resp = JSON.parse(response)
  resp.each do |o|
    r = JSON.parse(@circonus["#{o['_check_bundle']}"].get)
    if r['display_name'].match(/srd|prd/) && r['type'] == "collectd"
      tags = r['tags'].each do |t|
        if t.match(/customer/)
          hostname = r['display_name'].split(' ')[0]
          customer = t.split(":")[1]
          checkid_tmp = r['_checks'].map { |x| x.gsub('/check/', '')}
          checkid = checkid_tmp[0]
          #printf("|%-40s|%-20s|%s\n", hostname, customer, checkid)
          data(hostname, customer, checkid)
        end
      end 
    end
  end

rescue RestClient::Exception => ex
  # deal with exceptions by accessing the returned json and printing out why
  result = JSON.parse(ex.http_body)
  puts "#{ex.http_code}: #{result['code']} (#{result['message']})"
end
