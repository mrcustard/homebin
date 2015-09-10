require 'circonus'

apitoken="5d2af6be-3953-4de6-8276-7d9365bb3b28"
appname="curl"
#@appname="Alan"
#
#hosts = ARGV[0]
##CIRCONUS_APISERVER="mon.vgtf.net"
#
server = "api.mon.vgtf.net"
#
c = Circonus.new(apitoken,appname)
c.set_server(server)
#
##agents = c.list_broker
puts c.list_check
##pp agents
##graphs = list_graph()
## Use the graph id from a specific graph to get info on it
##get_graph('/graph/a3e7ea60-de42-4734-b638-6a6d8af34070')
##puts agents
