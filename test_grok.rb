#!/usr/bin/env ruby
#

require 'pp'
require 'json'
require 'grok-pure'

grok = Grok.new
Dir.glob('patterns/*').each do |pattern|
  grok.add_patterns_from_file(pattern)
end


text = 'May 10 06:41:11 cmapi1 postfix/smtpd[26140]: 8720C602E2: client=unknown[10.60.238.78]'
pattern = '%{SYSLOGTIMESTAMP} %{HOST}'
grok.compile(pattern)
if grok.match(text)
  pp grok.match(text).captures()
else
  puts "No Match"
end

