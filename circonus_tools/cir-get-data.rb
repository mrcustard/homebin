#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'rest_client'
require 'pp'

f = open('./config.json', 'r').read
@j = JSON.parse(f)

checkid = 139661
# Setup time 
  hours = @j['hours'] # Change this in the config.json file
  endtime = Time.now.to_i # get the current time and convert to epoch
  starttime = endtime - (hours * 60 * 60) # convert hours to seconds and subtract from the current time epoch

  # build the url
  cpu    = "/data/#{checkid}_#{@j['cpu']}?type=numeric&start=#{starttime}&end=#{endtime}&period=#{@j['period']}"
  memory = "/data/#{checkid}_#{@j['memory']}?type=numeric&start=#{starttime}&end=#{endtime}&period=#{@j['period']}"
  disk   = "/data/#{checkid}_#{@j['disk']}?type=numeric&start=#{starttime}&end=#{endtime}&period=#{@j['period']}"

# setup client
circonus = RestClient::Resource.new('https://api.mon.vgtf.net', :headers => {
  :x_circonus_app_name => @j['app'],
  :x_circonus_auth_token => @j['apitoken'],
  :accept => :json,
})

begin
  response = circonus["#{cpu}"].get  
  puts JSON.parse(response)

rescue RestClient::Exception => ex
  # deal with exceptions by accessing the returned json and printing out why
  result = JSON.parse(ex.http_body)
  puts "#{ex.http_code}: #{result['code']} (#{result['message']})"
end

