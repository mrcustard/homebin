#!/usr/bin/env ruby

require 'json'
require 'circonus'

f = open('./config.json', 'r').read
@j = JSON.parse(f)

hours = @j['hours'] # Change this in the config.json file
@endtime = Time.now.to_i # get the current time and convert to epoch
@starttime = @endtime - (hours * 60 * 60) # convert hours to seconds and subtract from the current time epoch
#puts "%-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % %w{ CPUMeanIdle CPUPeakIdle MemMeanUsed MemPeakUsed DiskMeanUsed DiskPeakUsed }
c = Circonus.new('a06a1a30-4249-4ec3-bb0b-e54c890a7f15', 'curl')
c.set_server('api.mon.vgtf.net')

#{
#  "cpuidle": "aggregation`cpu-average`cpu`idle",
#  "cpuint": "aggregation`cpu-average`cpu`interrupt",
#  "cpunice": "aggregation`cpu-average`cpu`nice",
#  "cpusoftirq": "aggregation`cpu-average`cpu`softirq",
#  "cpusteal": "aggregation`cpu-average`cpu`steal",
#  "cpusystem": "aggregation`cpu-average`cpu`system",
#  "cpuuser": "aggregation`cpu-average`cpu`user",
#  "cpuwait": "aggregation`cpu-average`cpu`wait"
#}


cpuidlelist = []
cpuintlist = []
cpunicelist = []
cpuirqlist = []
cpusteallist = []
cpusystemlist = []
cpuuserlist = []
cpuwaitlist = []
memlist = []
disklist = []

cpuidle = @j['cpu']['cpuidle']
cpuint = @j['cpu']['cpuint']
cpunice =@j['cpu']['cpunice']
cpusoftirq = @j['cpu']['cpusoftirq']
cpusteal = @j['cpu']['cpusteal']
cpusystem = @j['cpu']['cpusystem']
cpuuser = @j['cpu']['cpuuser']
cpuwait = @j['cpu']['cpuwait']


begin
  c.get_data('134110', cpuidle, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpuidlelist << line[1]['counter'] 
  end
 c.get_data('134110', cpuint, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpuintlist << line[1]['counter'] 
  end

 c.get_data('134110', cpunice, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpunicelist << line[1]['counter'] 
  end

 c.get_data('134110', cpusoftirq, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpuirqlist << line[1]['counter'] 
  end

 c.get_data('134110', cpusteal, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpusteallist << line[1]['counter'] 
  end

 c.get_data('134110', cpusystem, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpusystemlist << line[1]['counter']
  end

 c.get_data('134110', cpuuser, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpuuserlist << line[1]['counter']
  end

 c.get_data('134110', cpuwait, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
    cpuwaitlist << line[1]['counter']
  end

  #c.get_data('134110', @j['memory'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
  #  memlist << line[1]['value']
  #end

  #c.get_data('134110', @j['disk'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
  #  disklist << line[1]['value']
  #end

  #puts "%-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % [(cpulist.reduce(&:+) / cpulist.length).round(2).to_s, cpulist.sort![-1].round(2).to_s, (memlist.reduce(&:+) / memlist.length).round(2).to_s, memlist.sort![-1].round(2).to_s, (disklist.reduce(&:+) / disklist.length).round(2).to_s, disklist.sort![-1].round(2).to_s ]
  #puts "%-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % [(cpulist.reduce(&:+) / cpulist.length).round(2).to_s, cpulist.sort![-1].round(2).to_s, ((memlist.reduce(&:+) / memlist.length) / 1024 / 1024 ).round(2).to_s, (memlist.sort![-1] / 1024 / 1024).round(2).to_s, ((disklist.reduce(&:+) / disklist.length)/ 1024 / 1024).round(2).to_s, (disklist.sort![-1] / 1024 / 1024).round(2).to_s ]
  #puts c.get_data('134110', @j['disk'], {'start' => @starttime, 'end' => @endtime})['data']
  rescue
    puts "%-20s, %-20s, %-20s, %-20s, %-20s, %-20s" % ['nil', 'nil', 'nil', 'nil', 'nil', 'nil']
  end

# peak
peakcpuidle    = cpuidlelist.sort![-1]
peakcpuint     = cpuintlist.sort![-1]
peakcpunice    = cpunicelist.sort![-1]
peakcpuirq     = cpuirqlist.sort![-1]
peakcpusteal   = cpusteallist.sort![-1]
peakcpusystem  = cpusystemlist.sort![-1]
peakcpuuser    =  cpuuserlist.sort![-1]
peakcpuwait    = cpuwaitlist.sort![-1]

puts "PEAK: " 
puts "Reduced Idle:       #{peakcpuidle}"
puts "Reduced CPU Int:    #{peakcpuint}"
puts "Reduced CPU NICE:   #{peakcpunice}"
puts "Reduced CPU IRQ:    #{peakcpuirq}"
puts "Reduced CPU Steal:  #{peakcpusteal}"
puts "Reduced CPU System: #{peakcpusystem}"
puts "Reduced CPU USER:   #{peakcpuuser}"
puts "Reduced CPU Wait:   #{peakcpuwait}"
puts ""
peakcpuidlepercent = ( peakcpuidle / (peakcpuidle + peakcpuint + peakcpunice + peakcpuirq + peakcpusteal + peakcpusystem + peakcpuuser + peakcpuwait) ) * 100
puts "Peak CPU Idle Percent: #{peakcpuidlepercent.round(2)}"
puts "" 

# average
cpuidle   = (cpuidlelist.reduce(&:+).round(2) / cpuidlelist.length)
cpuint    = (cpuintlist.reduce(&:+).round(2) / cpuintlist.length)
cpunice   = (cpunicelist.reduce(&:+).round(2) / cpunicelist.length)
cpuirq    = (cpuirqlist.reduce(&:+).round(2) / cpuirqlist.length)
cpusteal  = (cpusteallist.reduce(&:+).round(2) / cpusteallist.length)
cpusystem = (cpusystemlist.reduce(&:+).round(2) / cpusystemlist.length)
cpuuser   = (cpuuserlist.reduce(&:+).round(2) / cpuuserlist.length)
cpuwait   = (cpuwaitlist.reduce(&:+).round(2) / cpuwaitlist.length)

# output
puts "Average:"
puts "Reduced Idle:       #{cpuidle}"
puts "Reduced CPU Int:    #{cpuint}"
puts "Reduced CPU NICE:   #{cpunice}"
puts "Reduced CPU IRQ:    #{cpuirq}"
puts "Reduced CPU Steal:  #{cpusteal}"
puts "Reduced CPU System: #{cpusystem}"
puts "Reduced CPU USER:   #{cpuuser}"
puts "Reduced CPU Wait:   #{cpuwait}"
puts ""
cpuidlepercent = (cpuidle / (cpuidle + cpuint + cpunice + cpuirq + cpusteal + cpusystem + cpuuser + cpuwait)) * 100
puts "CPU Average Idle Percent: #{cpuidlepercent.round(2)}"


def idbquery(hostname)
  uri = URI.parse("http://idb.services.dmtio.net/hosts?q=host:#{hostname}+AND+NOT+offline:true&fields=owner,package_size")
  resp = Net::HTTP.get_response(uri)
  j = JSON.parse(resp.body)
  puts j.map { |x| x['owner'] }
end

puts idbquery("prd-10-60-160-48.nodes.56m.dmtio.net")
