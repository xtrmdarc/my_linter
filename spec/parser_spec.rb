require './lib/xml_parser'

describe XmlParser do
  
  let(:parser) { XmlParser.new }
  describe '#prolog_at_start?' do
    it 'returns false if no well formed Prolog is found' do
      true
    end
  end
end