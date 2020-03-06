class FileReader
  def self.get_content_from_file(path)
    file = File.open(path)
    content = file.readlines.map(&:chomp)
    file.close
    content
  end
end
