#!/usr/bin/env ruby
# This script will build a fake ip address for use in testing

require 'json'

$config = "#{ENV['HOME']}/.fakeip.conf" # Set the network, should be first 3 oct.
$network = JSON.parse(File.open($config, 'r').read)['network']

def generateip()
  r = Random.new
  return "#{$network}.#{r.rand(0..254)}"
end

if __FILE__ == $0
  r = Random.new
  (1..100).each do |n|
    puts "#{$network}.#{r.rand(0..254)}"
  end
end



