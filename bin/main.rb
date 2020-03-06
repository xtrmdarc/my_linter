#!/usr/bin/env ruby
require_relative '../lib/xml_parser.rb'
require_relative '../lib/file_reader.rb'

content = FileReader.get_content_from_file('./test.xml')

xml_parser = XmlParser.new content

xml_parser.validate
