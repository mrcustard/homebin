#!/usr/bin/env ruby
#

require 'json'
require 'circonus'

f = open('config.json', 'r').read
config = JSON.parse(f)

c = Circonus.new('a06a1a30-4249-4ec3-bb0b-e54c890a7f15', 'curl')
c.set_server('api.mon.vgtf.net')
starttime = Time.now.to_i - ( 24 * 60 * 60 )
endtime = Time.now.to_i

cpulist = []
memlist = []
disklist = []

c.get_data('139661', config['cpu'], {'start' => starttime, 'end' => endtime})['data'].each do |line|
  cpulist << line[1]['counter']
end

c.get_data('139661', config['memory'], {'start' => starttime, 'end' => endtime})['data'].each do |line|
  memlist << line[1]['counter']
end

c.get_data('139661', config['disk'], {'start' => starttime, 'end' => endtime})['data'].each do |line|
  disklist << line[1]['counter']
end

puts "%-20s %-20s %-20s %-20s %-20s %-20s %-20s" % %w{ Hostname CPUMean CPUPeak MemMean MemPeak DiskMean DiskPeak }
puts "%-20s %-20s %-20s %-20s %-20s %-20s %-20s" % ['somehost', (cpulist.reduce(&:+) / cpulist.length).to_s, cpulist.sort![-1].to_s, ((memlist.reduce(&:+) / memlist.length) / 2024 ).to_s, (memlist.sort![-1] / 2024).to_s, (disklist.reduce(&:+) / disklist.length).to_s, disklist.sort![-1].to_s ]
#puts "%0.2f" % (cpulist.reduce(&:+) / cpulist.length)
#puts "%0.2f" % cpulist.sort![-1]
#
#puts "%0.2f" % ((memlist.reduce(&:+) / memlist.length) / 1024 )
#puts "%0.2f" % (memlist.sort![-1] / 1024)
#
#puts "%0.2f" % (disklist.reduce(&:+) / disklist.length) 
#puts "%0.2f" % disklist.sort![-1]
