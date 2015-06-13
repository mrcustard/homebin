#!/usr/bin/env ruby
#

# find the standard diviation
alist = [3,4,6,7]
mean = alist.reduce(:+) / alist.length
sum = 0 
alist.each do |num|
  sum += (num - mean)**2 
end
stddiv = Math.sqrt( sum / alist.length)
puts "N is #{alist.length}"
puts "Mean: #{mean}"
puts "StdDiv: #{stddiv}"

# so far the result is incorrect ... it should be 1.58 for std div.
# Given that alist is 3,4,6,7
