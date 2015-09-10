#!/usr/bin/env ruby

# examples of what the config file looks like
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

def get_cpu_utilization(checkid)
  # This function returns two values: peakcpu_utilzed, avgcpu_utilized 
  # To use this funtion within your script call it like so: pu, au = get_cpu_utilization(<checkid>)
  
  cpuidlelist = []
  cpuintlist = []
  cpunicelist = []
  cpuirqlist = []
  cpusteallist = []
  cpusystemlist = []
  cpuuserlist = []
  cpuwaitlist = []

  cpuidle = @j['cpu']['cpuidle']
  cpuint = @j['cpu']['cpuint']
  cpunice =@j['cpu']['cpunice']
  cpusoftirq = @j['cpu']['cpusoftirq']
  cpusteal = @j['cpu']['cpusteal']
  cpusystem = @j['cpu']['cpusystem']
  cpuuser = @j['cpu']['cpuuser']
  cpuwait = @j['cpu']['cpuwait']
 
  begin
    @c.get_data(checkid, cpuidle, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpuidlelist << line[1]['counter'] 
    end
   @c.get_data(checkid, cpuint, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpuintlist << line[1]['counter'] 
    end
  
   @c.get_data(checkid, cpunice, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpunicelist << line[1]['counter'] 
    end
  
   @c.get_data(checkid, cpusoftirq, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpuirqlist << line[1]['counter'] 
    end
  
   @c.get_data(checkid, cpusteal, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpusteallist << line[1]['counter'] 
    end
  
   @c.get_data(checkid, cpusystem, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpusystemlist << line[1]['counter']
    end
  
   @c.get_data(checkid, cpuuser, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpuuserlist << line[1]['counter']
    end
  
   @c.get_data(checkid, cpuwait, {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      cpuwaitlist << line[1]['counter']
    end
  
    peakcpuidle    = cpuidlelist.sort![-1]
    peakcpuint     = cpuintlist.sort![-1]
    peakcpunice    = cpunicelist.sort![-1]
    peakcpuirq     = cpuirqlist.sort![-1]
    peakcpusteal   = cpusteallist.sort![-1]
    peakcpusystem  = cpusystemlist.sort![-1]
    peakcpuuser    =  cpuuserlist.sort![-1]
    peakcpuwait    = cpuwaitlist.sort![-1]
    
    # Get the peak cpu utilized - a single data point over the 24 hour period 
    peakcpu_utilzed = 100 - (( peakcpuidle / (peakcpuidle + peakcpuint + peakcpunice + peakcpuirq + peakcpusteal + peakcpusystem + peakcpuuser + peakcpuwait) ) * 100 )
  
    cpuidle   = (cpuidlelist.reduce(&:+).round(2) / cpuidlelist.length)
    cpuint    = (cpuintlist.reduce(&:+).round(2) / cpuintlist.length)
    cpunice   = (cpunicelist.reduce(&:+).round(2) / cpunicelist.length)
    cpuirq    = (cpuirqlist.reduce(&:+).round(2) / cpuirqlist.length)
    cpusteal  = (cpusteallist.reduce(&:+).round(2) / cpusteallist.length)
    cpusystem = (cpusystemlist.reduce(&:+).round(2) / cpusystemlist.length)
    cpuuser   = (cpuuserlist.reduce(&:+).round(2) / cpuuserlist.length)
    cpuwait   = (cpuwaitlist.reduce(&:+).round(2) / cpuwaitlist.length)
  
    avgcpu_utilized = 100 - ((cpuidle / (cpuidle + cpuint + cpunice + cpuirq + cpusteal + cpusystem + cpuuser + cpuwait)) * 100) 
    return peakcpu_utilzed, avgcpu_utilized
  rescue
    return 'nil', 'nil' 
  end # End of begin statement
end # End of get_cpu_utilization

#peakcpu_utilized, avgcpu_utilized = get_cpu_utilization('134110')
#puts "Peak CPU Utilization Pct: #{peakcpu_utilized.round(2)}"
#puts "CPU Average Utilization Pct: #{avgcpu_utilized.round(2)}"
#puts ""

