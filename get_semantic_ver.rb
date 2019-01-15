#!/usr/bin/ruby -w

require 'semantic'

version = Semantic::Version.new(ARGV[0])
new_version = version.increment!(:patch)

STDERR.puts "Bump up from #{version.major}.#{version.minor}.#{version.patch} ----> #{new_version.to_s}"

puts new_version.to_s

