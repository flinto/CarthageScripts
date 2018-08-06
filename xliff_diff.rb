#!/usr/bin/ruby -w
require 'nokogiri'


src = Nokogiri::XML(File.open(ARGV[0]))
dst = Nokogiri::XML(File.open(ARGV[1]))
src.encoding = 'UTF-8'
dst.encoding = 'UTF-8'

dict = {}

src.xpath("//xliff:trans-unit", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |trans|
  dict[trans.attr("id")] = trans
end

dst.xpath("//xliff:trans-unit", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |trans|
  if dict.has_key?(trans.attr("id"))
    dict.delete(trans.attr("id"))
  else
    puts "New: \"#{trans.attr("id")}\" #{trans.at("note")}"
  end
end

dict.each do |key, trans|
  puts "Removed: \"#{key}\" #{trans.at("note")}"
end

