#!/usr/bin/ruby

require 'json'
require 'rest_client'
require 'circonus'

require_relative './lib/getcpu'
require_relative './lib/getmem'
require_relative './lib/getdisk'
require_relative './lib/getnodeinfo'

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

@c = Circonus.new('a06a1a30-4249-4ec3-bb0b-e54c890a7f15', 'curl')
@c.set_server('api.mon.vgtf.net')

puts "%-37s %-20s %-20s %-20s %-20s %-20s %-20s %-20s" % %w{ Hostname Customer PackageSize AvgCPUutilized PeakCPUutilzed AVGMemUsed PeakMemUsed AVGDiskUsed PeakDiskUsed }
def create_report(hostname, customer, checkid)
  peakcpu_utilized, avgcpu_utilzed = get_cpu_utilization(checkid)
  peakmem, avgmem = get_memory(checkid)
  peakdisk, avgdisk = get_disk_info(checkid)
  package_size = idbquery(hostname, 'package_size')
  puts "%-37s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % [hostname, customer, package_size, avgcpu_utilzed, peakcpu_utilized, avgmem, peakmem, avgdisk, peakdisk ]
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
          puts "got host"
          #printf("|%-40s|%-20s|%s\n", hostname, customer, checkid)
          create_report(hostname, customer, checkid)
        end
      end 
    end
  end
rescue RestClient::Exception => ex
  # deal with exceptions by accessing the returned json and printing out why
  result = JSON.parse(ex.http_body)
  puts "#{ex.http_code}: #{result['code']} (#{result['message']})"
end
