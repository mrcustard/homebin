#!/usr/bin/env ruby
#

require 'mmonit'

m = MMonit::Connection.new({:ssl => false, :username => 'admin', :password => 'swordfish', :address => 'mmonit.56m.dmtio.net', :port => '8080'})
m.status.each do |stat|
  if stat['status'].match(/No report from Monit/)
    m.request("/admin/hosts/delete", "id=#{stat['id']}")
  end
end
