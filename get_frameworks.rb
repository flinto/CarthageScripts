#!/usr/bin/ruby -w


frameworks=[]
cartfile = File.new("./Cartfile", "r")
while line = cartfile.gets
  if line =~ /^github \"flinto\/(.*)\"/
    if ARGV.include?($1) == false
      frameworks.push($1)
    end
  end
end
cartfile.close
print frameworks.join(" ")

