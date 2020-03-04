#!/usr/bin/env ruby
require './lib/xml_parser'

file = File.open("./test.xml")
content = file.readlines.map(&:chomp)
file.close

xml_parser = XmlParser.new content
result = xml_parser.prolog_at_start?
result = xml_parser.well_formed_attributes?
result = xml_parser.single_node?
result = xml_parser.has_attributes?
result = xml_parser.get_node_name
p result