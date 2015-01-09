#!/usr/bin/env ruby
#
# This script will change the text in a cookbook 
#

$searchline = ARGV[0] 
$replaceline = ARGV[1] 

Dir["**/*.rb"].each do |file|
  File.open(file, 'r+').each_line do |line|
    if line =~ /#{$searchline}/
      puts "#{file}\t\t #{line}"
    end
  end
end
