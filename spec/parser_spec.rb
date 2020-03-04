require './lib/xml_parser'
require './lib/file_reader'

describe XmlParser do
  let(:test_path) { './test_files/' }
  let(:sample_parser) { XmlParser.new []}

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

  describe '#well_formed_node?' do
    it 'returns false if no well formed node is found' do
      content_to_parse = 'asdas < >'
      
      expect(sample_parser.well_formed_node?(content_to_parse,0)).not_to eql(true)
    end

    it 'returns true if well formed multiline node is found' do
      content_to_parse = '<order>'
      expect(sample_parser.well_formed_node?(content_to_parse,0)).to eql(true)
    end

    it 'returns true if well formed inline node is found' do
      content_to_parse = '<order>val</order>'
      expect(sample_parser.well_formed_node?(content_to_parse,0)).to eql(true)
    end

    it 'returns false if a missing closing bracket node is found' do
      content_to_parse = '<order'
      expect(sample_parser.well_formed_node?(content_to_parse,0)).not_to eql(true)
    end
  end

  describe '#well_formed_attributes?' do
    it 'returns false if no well formed attribute is found inside the node' do
      content_to_parse = '<order attr  >'
      
      expect(sample_parser.well_formed_attributes?(content_to_parse,0)).not_to eql(true)
    end

    it 'returns true if well formed attribute is found inside a multiline node' do
      content_to_parse = '<order attr="val"  >'
      
      expect(sample_parser.well_formed_attributes?(content_to_parse,0)).to eql(true)
    end

    it 'returns true if well formed attribute is found inside a inline node' do
      content_to_parse = '<order attr="val">value</order>'
      
      expect(sample_parser.well_formed_attributes?(content_to_parse,0)).to eql(true)
    end

    it 'returns false if attribute uses single quotation notation' do
      content_to_parse = "<order attr='val'>"
      
      expect(sample_parser.well_formed_attributes?(content_to_parse,0)).not_to eql(true)
    end
  end

  describe '#single_node?' do
    it 'returns true if multiline node is found' do
      content_to_parse = '<order>'
      
      expect(sample_parser.single_node?(content_to_parse)).to eql(true)
    end

    it 'returns true if multiline node with attributes is found' do
      content_to_parse = '<order attr="val">'
      
      expect(sample_parser.single_node?(content_to_parse)).to eql(true)
    end

    it 'returns false if inline node is found' do
      content_to_parse = '<order>value</order>'
      
      expect(sample_parser.single_node?(content_to_parse)).not_to eql(true)
    end
  end

  describe '#attributes?' do
    it 'returns true if node has attributes' do
      content_to_parse = '<order atr="a">value</order>'
      
      expect(sample_parser.attributes?(content_to_parse)).to eql(true)
    end

    it 'returns false if node has attributes' do
      content_to_parse = '<order>value</order>'
      
      expect(sample_parser.attributes?(content_to_parse)).not_to eql(true)
    end
  end

  describe '#get_node_name' do
    it 'returns the name of an inline node of its opening bracket' do
      content_to_parse = '<order>value</order>'
      
      expect(sample_parser.get_node_name(content_to_parse)).to eql('order')
    end

    it 'returns the the name of a multiline node of its opening bracket' do
      content_to_parse = '<order>'
      
      expect(sample_parser.get_node_name(content_to_parse)).to eql('order')
    end
  end
  
  describe '#get_node_name_last' do
    it 'returns the name of an inline node of its closing bracket' do
      content_to_parse = '<order>value</orders>'
      
      expect(sample_parser.get_node_name_last(content_to_parse)).to eql('orders')
    end

    it 'returns the name of an multiline node of its closing bracket' do
      content_to_parse = '</orders>'
      
      expect(sample_parser.get_node_name_last(content_to_parse)).to eql('orders')
    end
  end
  
end
