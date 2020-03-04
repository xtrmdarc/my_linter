#!/usr/bin/env ruby
require './lib/xml_parser'

file = File.open("./test.xml")
content = file.readlines.map(&:chomp)
file.close

xml_parser = XmlParser.new content

xml_parser.validate