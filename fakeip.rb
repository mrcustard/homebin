#!/usr/bin/env ruby
# This script will build a fake ip address for use in testing

r = Random.new
(1..100).each do |n|
  puts "10.50.0.#{r.rand(0..254)}"
end



