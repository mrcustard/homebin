#!/usr/bin/env ruby
#

require 'grok-pure'
require 'pp'

grok = Grok.new

Dir.glob('patterns/*').each do |pattern|
  grok.add_patterns_from_file(pattern) 
end

f = open('patterns/postfix.grok', 'r').readlines.each do |line|
  line.split(' ')[0].gsub(/#/, '').chomp 
end

pattern = '(%{TIMESTAMP_ISO8601:timestamp}|%{SYSLOGTIMESTAMP:timestamp}) %{SYSLOGHOST:host} %{DATA:program}(?:\[%{POSINT:pid}\])?: %{GREEDYDATA:message}'

grok.compile(pattern)
puts "PATTERN: #{pattern}"

while a = gets
  puts "IN: #{a}"
  match = grok.match(a)
  if match
    #puts "MATCH:"
    match['message']
  else
    puts "No Match"
  end
end
