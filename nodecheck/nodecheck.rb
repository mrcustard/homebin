#!/usr/bin/env ruby

#
# A script designed to check a node,
# and determine basic information about
# the node, and then create a report for
# the oncall.
#

require 'resolv'
require 'net/ssh'
require 'net/ping'

class Machine
  def initialize 
    @home = ENV['HOME']
    @nodename = ARGV[0]
  end

  def test_node(@nodename)
    # ssh to the host if possible
    begin
      Net::SSH.start()
    rescue
      if Resolv.getaddress(@nodename)
        #DNS appears to be working
        if Net::Ping::External.new(@nodename)
          puts "Unable to ssh to #{@nodename}, host down?"
        end
      else
        puts "Trouble with DNS, on your local machine?" 
      end

      puts "Unable to ssh to #{@nodename}, host down?"
    end
    
  end

  def create_report(info)

  end

end
