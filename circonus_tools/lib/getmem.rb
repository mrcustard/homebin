memlist = []

def get_memory(checkid)
  begin
    @c.get_data(checkid, @j['memory'], {'start' => @starttime, 'end' => @endtime})['data'].each do |line|
      memlist << line[1]['value']
    end
    peakmem = (memlist.sort![-1] / 1024 / 1024).round(2).to_s
    avgmem  = ((memlist.reduce(&:+) / memlist.length) / 1024 / 1024 ).round(2).to_s
    return peakmem, avgmem
  rescue
    return 'nil', 'nil'
  end
end
