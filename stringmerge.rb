#!/usr/bin/ruby -w

dict = {}

#lang = ARGV[0]
base = File.new(ARGV[1], "r:UTF-8")
while line = base.gets
  if line =~ /^\"([\w\-\.\[\]]+)\"\s*\=\s*\"(.*)\"\;.*$/
    dict[$1] = line
  end
end
base.close

out = File.new(ARGV[1], "w:utf-8")
loc = File.new(ARGV[2], "r:bom|UTF-16LE:UTF-8")
while line = loc.gets
  # if line =~ /(ibShadowedMultipleValuesPlaceholder|ibShadowedNoSelectionPlaceholder|ibShadowedNotApplicablePlaceholder|ibShadowedIsNilPlaceholder).*\" \"/
  #   next
  # end
  # if line =~ /__DEBUG__/
  #   if lang == 'en.lproj'
  #     out.puts line
  #     text = loc.gets
  #     out.puts text.gsub(/__DEBUG__/, '')
  #   else
  #     loc.gets
  #     loc.gets
  #   end
  #   next
  # elsif line =~ /(__[A-Z_]+__)/
  #   loc.gets
  #   loc.gets
  #   next
  # end
  if line =~ /^\"([\w\-\.\[\]]+)\"\s*\=\s*\"(.*)\"\;.*$/
    if dict[$1]
      out.puts dict[$1]
    else
      out.puts line.strip + " /* NEW */"
    end
  else
    out.puts line
  end
end

