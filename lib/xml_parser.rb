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
    false
  end

  def well_formed_attributes?(line)
    if /([A-Za-z]+=\".+\")+/ === line
      puts "[TEST PASSED] : All attributes are well formed"
      return true
    end
    puts "[ERROR] : No well formed Attribute"
    return false
  end

  def single_node?(line)
    if /^<\/?[A-Za-z]+\s*>/ === line
      puts "[SINGLE NODE]"
      return true
    end
    puts "NOT A SINGLE NODE"
    false
  end

  def check_closing_tag_inline(line)
    node_name = get_node_name(line)
    node_name_last = get_node_name_last(line)
    puts node_name
    puts node_name_last
    if node_name == node_name_last
      puts '[TEST PASSED] Matching closing backet'
    else
      puts '[ERROR] No matching closing bracket'
    end
  end

  def has_attributes?(line)
    if /^\s*<[A-Za-z]+\s+.+>$/ === line
      puts "[IT HAS ATTRUBTES]"
      return true
    end
    puts "NO ATTRIBUTES"
    false
  end

  def get_node_name(line)
    return line[/^\s*<\s*([A-Za-z]+).*/, 1]
  end

  def get_node_name_last(line)
    return line[/<\s*\/\s*([A-Za-z]+).*/, 1]
  end

  def adm_multi_line_node(line)
    if get_node_name(line) &&  get_node_name(line) != ''
      @multi_line_buffer << get_node_name(line)
    elsif get_node_name_last(line) && get_node_name_last(line) != ''
      @multi_line_buffer.delete(get_node_name_last(line))
    end
  end

  def validate
    prolog_at_start?

    1.upto(@input.length - 1) do |i|
      line = @input[i]
      puts line
      if single_node?(line)
        adm_multi_line_node(line)
      else
        check_closing_tag_inline(line)
        well_formed_attributes?(line) if has_attributes?(line)   
      end
    end
    p @multi_line_buffer
  end

end
