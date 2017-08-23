#!/usr/bin/ruby -w


def load_keys(file, option)
dict = {}
  base = File.new(ARGV[0], option)
  while line = base.gets
    if line =~ /^\"(.*)\"\s*\=\s*\".*$/
      dict[$1] = line
    end
  end
  base.close
  return dict
end

dict = load_keys(ARGV[0], "r:UTF-8")
newdict = load_keys(ARGV[1], "r:UTF-8")

dict.each {|k, v|
  if newdict[k] == nil
    dict[k] = nil
  end
}


out = File.new(ARGV[0], "w")
loc = File.new(ARGV[1], "r:UTF-8")
while line = loc.gets
  if line =~ /^\"(.*)\"\s*\=\s*\".*$/
    if dict[$1]
      out.puts dict[$1]
    else
      out.puts line.strip + " /* NEW */"
    end
  else
    out.puts line
  end
end

