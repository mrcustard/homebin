#!/usr/bin/env ruby


f = open('patterns/postfix.grok', 'r').readlines
entry = [] 
f.each do |line|
  entry << line.split(' ')[0].gsub(/#/, '').chomp + "|"
end
puts entry
