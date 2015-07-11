#!/usr/bin/env ruby
#

require 'uri'
require 'json'
require 'net/http'

payload = { 'commands' => { 'allocate' => { 'index' => ARGV[1], 'shard' => ARGV[2], 'allow_primary' => true } } }

net = Net::HTTP.new("#{ARGV[0]}", 9200)
request = Net::HTTP::Post.new('/_cluster/reroute')
request.set_form_data(payload)

net.read_timeout = 10
net.open_timeout = 10 

response = net.start do |http|
  http.request(request)
end

puts response.code
puts response.read_body
