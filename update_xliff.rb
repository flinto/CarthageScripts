#!/usr/bin/ruby -w
require 'nokogiri'


doc = Nokogiri::XML(File.open(ARGV[0]))
doc.encoding = 'UTF-8'

doc.xpath("//xliff:trans-unit", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |trans|
  next unless trans.at("note")
  source = trans.at("source").content
  if source =~ /(__[A-Za-z_]+__)/
    trans.at("source").content = trans.at("source").content.sub '; Note="Do not translate";', ''
    trans.at("source").content += '; Note="Do not translate";'
  end
  if trans.attr("id") =~ /ibShadowedMultipleValuesPlaceholder|ibShadowedIsNilPlaceholder|ibShadowedNoSelectionPlaceholder|ibShadowedNotApplicablePlaceholder/
    if trans.at("source").content =~ /^(\s+|0)$/
    trans.at("source").content.sub '; Note="Do not translate";', ''
    trans.at("source").content += '; Note="Do not translate";'
    end
  end
end

puts doc



