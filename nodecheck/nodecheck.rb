#!/usr/bin/env ruby

#
# A script designed to check a node,
# and determine basic information about
# the node, and then create a report for
# the oncall.
# this will hopfully be multithreaded ....

require 'resolv'
require 'net/ssh'
require 'net/ping'

class Machine
  def initialize 
    @home = ENV['HOME']
    @nodename = ARGV[0]
  end

  def test_node(@nodename, restart=false)
    info = {}
    # ssh to the host if possible
    begin
      Net::SSH.start()
      # Check for the following:
      # check   -  uptime
      # check   - disk (df -h)
      # check   - load (related to uptime)
      # check   - process
      # check   - application port via url if provided
      # record  - default gateway
      # record  - network
      # record  - network address
      # restart - process if possible restart in json exists
      info['uptime'] = ''
      info['disk']   = ''
      info['load']   = ''
      info['process'] = '' # this should be a status (running|stopped)
      info['gateway'] = ''
      info['network'] = ''
      info['netaddress'] = ''
      if restart = true
        info['restart'] = '' #add the restart command to the report.
      end

    rescue
      if Resolv.getaddress(@nodename)
        #DNS appears to be working
        if Net::Ping::External.new(@nodename)
          puts "Unable to ssh to #{@nodename}, host down?"
          info['hoststatus'] = 'down'
        end
      else
        puts "Trouble with DNS, on your local machine?" 
      end

      puts "Unable to ssh to #{@nodename}, host down?"
    end
    create_report(info) 
  end

  def create_report(info)
    # Here we want to create a report with all of the 
    # information that we gathered from ssh'ing into the machine
    # pinging the machine
    # checking it's application port(s)
    # default gateway, etc ...

    info do |key, value|
      puts "Report for #{key}:" 
      puts "    #{value}"

    end

  end

  def request_host_info() # only works on argo - need to test for network to determine if it's argo
    # this will pull information from idb 
    # about a host, in particular it's restart
    # command and allow the script to restart,
    # and to grab the health check url 
    return hostinfo
  end
end
