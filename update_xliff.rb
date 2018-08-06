#!/usr/bin/ruby -w
require 'nokogiri'


doc = Nokogiri::XML(File.open(ARGV[0]))
doc.encoding = 'UTF-8'

doc.xpath("//xliff:file", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |file|
  original = file.attr("original")
  if original =~ /Info.plist/ || original =~ /InfoPlist.strings/
    file.remove
  end
end

doc.xpath("//xliff:trans-unit", "xliff" => "urn:oasis:names:tc:xliff:document:1.2").each do |trans|
  source = trans.at("source").content

  if trans.attr("id") =~ /ibShadowedMultipleValuesPlaceholder|ibShadowedIsNilPlaceholder|ibShadowedNoSelectionPlaceholder|ibShadowedNotApplicablePlaceholder/
    if trans.at("source").content =~ /^(\s|0)*$/
      trans.remove
    end
  end

  trans.at("source").content = source.gsub(/\\\"/, '"')

  if source =~ /(__DEBUG)/
    trans.remove
  end
  if source =~ /(__PLACEHOLDER)/
    trans.remove
  end

  if source =~ /(__[A-Za-z_]+__)/
    trans.remove
  end


  next unless trans.at("note")
  note = trans.at("note").content


  if note =~ /(__DEBUG)/
    trans.remove
  end
  if note =~ /(__PLACEHOLDER)/
    trans.remove
  end
  if note =~ /Note\s*=\s*\"Do not translate\";/im
    trans.remove
  end

end

puts doc



