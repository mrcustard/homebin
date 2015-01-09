#!/usr/bin/env ruby
#

require 'fileutils'

cb_dir_name="/Users/mgibson/repos/turner/cookbooks"
sym_dir_name="/Users/mgibson/repos/turner/syms/"

Dir.glob(File::join(cb_dir_name, '*')).each do |cbdir|
  new_dir = ::File::join(sym_dir_name, cbdir.split("/")[-1])
  puts cbdir, new_dir
  FileUtils.ln_s(cbdir, new_dir)
end
