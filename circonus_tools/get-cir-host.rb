#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'rest_client'
require 'pp'

f = open('./config.json', 'r').read
@j = JSON.parse(f)

# setup client
@circonus = RestClient::Resource.new('https://api.mon.vgtf.net', :headers => {
  :x_circonus_app_name => "#{@j['app']}",
  :x_circonus_auth_token => "#{@j['apitoken']}",
  :accept => :json,
})

def data(checkid)
  # Setup time 
  hours = @j['hours'] # Change this in the config.json file
  endtime = Time.now.to_i # get the current time and convert to epoch
  starttime = endtime - (hours * 60 * 60) # convert hours to seconds and subtract from the current time epoch

  begin
  response = circonus[cpu].get  pp JSON.parse(response)

  rescue RestClient::Exception => ex
    # deal with exceptions by accessing the returned json and printing out why
    result = JSON.parse(ex.http_body)
    puts "#{ex.http_code}: #{result['code']} (#{result['message']})"
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
          printf("|%-40s|%-20s|%s\n", hostname, customer, r['_checks'].map { |x| x.gsub('/check/', '').to_i})
        end
      end 
    end
  end

rescue RestClient::Exception => ex
  # deal with exceptions by accessing the returned json and printing out why
  result = JSON.parse(ex.http_body)
  puts "#{ex.http_code}: #{result['code']} (#{result['message']})"
end
