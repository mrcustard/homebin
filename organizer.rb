#!/usr/bin/env ruby

# Attempt to organize my files automatically

filelist = Dir.glob('*')
ext = []
filelist.each do |file|
  ext << file.gsub(/.*\./, '')
end

puts ext.sort.uniq
