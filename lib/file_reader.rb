
class FileReader < File

  def self.get_content_from_file(path)
    file = open(path)
    content = file.readlines.map(&:chomp)
    file.close
    content
  end
end