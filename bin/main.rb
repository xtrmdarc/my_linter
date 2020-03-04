#!/usr/bin/env ruby
require './lib/xml_parser'
require './lib/file_reader'

content = FileReader.get_content_from_file('./test.xml')

xml_parser = XmlParser.new content

xml_parser.validate
