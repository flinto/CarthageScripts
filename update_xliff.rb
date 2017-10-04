#!/usr/bin/ruby -w
require 'nokogiri'


doc = Nokogiri::XML(File.open(ARGV[0]))
doc.encoding = 'UTF-8'

doc.xpath("//xliff:file", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |file|
  if file.attr("original") =~ /Info.plist/
    file.remove
  end
end

doc.xpath("//xliff:trans-unit", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |trans|
  next unless trans.at("note")
  source = trans.at("source").content
  if source =~ /(__[A-Za-z_]+__)/
    trans.remove
  end
  if source =~ /(__[A-Za-z_]+__)/
    trans.remove
  end
  if source =~ /Note=\"Do not translate\";/
    trans.remove
  end
  if trans.attr("id") =~ /ibShadowedMultipleValuesPlaceholder|ibShadowedIsNilPlaceholder|ibShadowedNoSelectionPlaceholder|ibShadowedNotApplicablePlaceholder/
    if trans.at("source").content =~ /^(\s+|0)$/
    trans.remove
    end
  end
end

puts doc



