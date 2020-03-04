require './lib/xml_parser'
require './lib/file_reader'

describe XmlParser do
  let(:test_path) { './test_files/' }

  describe '#prolog_at_start?' do
    it 'returns false if no well formed Prolog is found at the start of the file' do
      xml_parser = XmlParser.new FileReader.get_content_from_file(test_path+'no_prolog.xml')
      expect(xml_parser.prolog_at_start?).not_to eql(true)
    end

    it 'returns true if well formed Prolog is found at the start of the file' do
      xml_parser = XmlParser.new FileReader.get_content_from_file(test_path+'prolog.xml')
      expect(xml_parser.prolog_at_start?).to eql(true)
    end

  end

end