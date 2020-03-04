class XmlParser
  
  def initialize(input)
    @input = input
    @multi_line_buffer = []
  end
  
  def prolog_at_start?
    puts @input[0]
    if /^<\?xml(\s*[a-z]*=\".*\"\s*)*\?>$/ === @input[0]
      puts "[TEST PASSED] : Prolog found"
      return true
    end
    puts "Warning: No well formed prolog at the start of the file"
    return false
  end

  def well_formed_attributes?(line= nil)
    puts @input[1]
    if /([a-z]+=\".+\")+/ === @input[1]
      puts "[TEST PASSED] : All attributes are well formed"
      return true
    end
    puts "[ERROR] : No well formed Attribute"
    return false
  end

  def single_node?(line=nil)
    puts @input[2]
    if /^<[a-z]+\s*>/ === @input[2]
      puts "[SINGLE NODE]"
      return true
    end
    puts "NOT A SINGLE NODE"
    false
  end

  def has_attributes?(line=nil)
    puts @input[2]
    if /^<[a-z]+\s+.+>/ === @input[2]
      puts "[IT HAS ATTRUBTES]"
      return true
    end
    puts "NO ATTRIBUTES"
    false
  end

  def get_node_name
    puts @input[2]
    return @input[2][/^<\s*([a-z]+).*/, 1]
  end

  def parse
    @input.each_with_index do |el, i|
      
    end
  end
end
