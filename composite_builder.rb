#!/usr/bin/env ruby

require 'rubygems'
require 'circonus'
require 'optparse'
require "#{ENV['HOME']}/.circonus.rb"

def do_update_check_bundle(data)
  search_check_bundle = @c.list_check_bundle({'display_name' => data['display_name']})
  existing = false
  if search_check_bundle.any? # already exists...
    existing = true
    r = @c.update_check_bundle(search_check_bundle.first['_cid'],data)
  else
    r = @c.add_check_bundle(data)
  end
  if not r.nil? then
    pp r
    print "Success (#{existing ? 'updating' : 'adding'} #{data['display_name']})\n"
  end
end


options = {}
options[:tags] = []
OptionParser.new { |opts|
  opts.banner = "Usage: #{File.basename($0)} [-h] [-t tag1,tag2,...]\n"
  opts.on( '-h', '--help', "This usage menu") do
    puts opts
    exit
  end
  opts.on( '--type TYPE',"Check bundle type" ) do |t|
    options[:type] = t
  end
  opts.on( '-t','--tags TAGLIST',"Use comma separated list of tags for searching (takes the union)" ) do |t|
    options[:tags] += t.split(/,/).sort.uniq
  end
}.parse!

def usage()
  print <<EOF
  Usage: #{File.basename($0)} -t tag1,tag2,... --type CHECKBUNDLETYPE
    -h,--help        This usage menu
    -t,--tags        Comma separated list of tag names to use
    --type           check bundle type (snmp, nginx, etc.)
EOF
end

raise "No tags given" unless options[:tags].any?
raise "No type given" unless options[:type]
@c = Circonus.new(@apitoken,@appname,@agent)

# the agent that will do composites for us:
agentid = @c.list_broker({'_name'=>'composite'}).first['_cid']

# checkbundles matching what we want:
checkbundles = @c.list_check_bundle().select { |s| ((s['tags'].sort.uniq & options[:tags]) == options[:tags]) and (s['type'] == options[:type]) }

# unique metric names:
metrics = checkbundles.map { |m| m['metrics'].map { |mn| mn['name'] } }.flatten.sort.uniq

# checkids in the group:
checkids = checkbundles.map { |m| m['_checks'] }.flatten

metrics.each do |metric|
  formula = '(' + checkids.map { |cid| "metric:counter(#{cid.split('/').last}, \"#{metric}\", 60000)" }.join(" + ") + ')'
  bundle = {
    "brokers"=>[agentid],
    "config"=>{
      "formula"=>formula
    },
    "display_name"=>"Composite Sum: #{options[:tags].join(',')} - #{metric}",
    "metrics"=>[
      {"name"=>metric, "status"=>"active", "type"=>"numeric"}
    ],
    "notes"=>nil,
    "period"=>60,
    "status"=>"active",
    "tags"=>options[:tags],
    "target"=>"ouzo.edge",
    "timeout"=>10,
    "type"=>"composite"
  }
  # add / update check bundle with data set
  pp bundle
end




