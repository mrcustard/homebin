#!/usr/bin/env ruby
#

require 'grok-pure'
require 'pp'

grok = Grok.new
grok.add_patterns_from_file("/Users/mgibson/repos/turner/cookbooks/cookbook-logstash-turner/templates/default/patterns/postfix.grok") # this could be any file or even a cli arg.

#pattern = 'your_grok_pattern_here'
#grok.compile
#puts "PATTERN: #{pattern}"

while a = gets
  puts "IN: #{a}"
  if a != nil
  match = grok.match(a)
  if match
    puts "MATCH:"
    pp match.captures
  else
    puts "No Match"
  end
  end
end
