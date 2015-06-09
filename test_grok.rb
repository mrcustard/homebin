#!/usr/bin/env ruby
#

require 'pp'
require 'grok-pure'

grok = Grok.new
grok.add_patterns_from_file("patterns/")

text = 'May 10 06:41:11 cmapi1 postfix/smtpd[26140]: 8720C602E2: client=unknown[10.60.238.78]'
pattern = '%{SYSLOGTIMESTAMP:timestamp}'

grok.compile(pattern)
pp grok.match(text).captures()
