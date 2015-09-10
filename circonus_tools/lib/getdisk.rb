def get_disk_info(checkid)
  disklist = []
  begin
    @c.get_data(checkid, @j['disk'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      disklist << line[1]['value']
    end 
    peakdisk = (disklist.sort![-1] / 1024 / 1024).round(2).to_s
    avgdisk  = ((disklist.reduce(&:+) / disklist.length) / 1024 / 1024).round(2).to_s
    return peakdisk, avgdisk
  rescue
    return 'nil', 'nil'
  end
end
