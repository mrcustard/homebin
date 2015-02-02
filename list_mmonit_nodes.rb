#!/usr/bin/env ruby
#

require 'mmonit'

m = MMonit::Connection.new({:ssl => false, :username => 'admin', :password => 'swordfish', :address => '10.60.160.185', :port => '8080'})
m.connect
#puts m.request("/admin/hosts/list").body
#puts m.status

puts m.request('/admin/hosts/list').body



