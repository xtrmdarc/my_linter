require './lib/file_reader'

describe FileReader do
  let(:test_path) { './test_files/' }
  describe '.get_content_from_file' do
    it 'returns an array filled with every line of the file' do
      expected_content = ['<root>', '  <node>val</node>', '</root>']
      content = FileReader.get_content_from_file(test_path + 'file_reader_test.xml')
      expect(content).to eql(expected_content)
    end
  end
end
