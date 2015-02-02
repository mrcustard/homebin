#!/usr/bin/env ruby
#
#

# Global $var
# Class @@var
# Instance @var
# Local var
# Block var

require 'mmonit'

$m = MMonit::Connection.new({:ssl => false, :username => 'admin', :password => 'swordfish', :address => 'mmonit.56m.dmtio.net', :port => '8080'})

#m.status.each do |stat|
#  if stat['status'].match(/No report from Monit/)
#    m.request("/admin/hosts/delete", "id=#{stat['id']}")
#  end
#end

# find the id of the node
def find_host(hostname)
  $m.status.each do |status|
    printf "#{status['id']} #{status['hostname']}" if status['hostname'] == hostname
  end
end

find_host('prd-10-60-160-185.nodes.56m.dmtio.net')
