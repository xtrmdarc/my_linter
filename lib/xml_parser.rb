class XmlParser
  def initialize(input)
    @input = input
    @multi_line_buffer = []
    @root_count = 0
    @root_closed = false
    @root = nil
  end

  def prolog_at_start?
    puts @input[0]
    if /^<\?xml(\s*[a-z]*=\'.*\'\s*)*\?>$/ === @input[0]
      puts '[TEST PASSED] : Prolog found'
      return true
    end
    puts 'Warning: No well formed prolog at the start of the file'
    false
  end

  def well_formed_attributes?(line, ln)
    if /([A-Za-z]+=\'.+\')+/ === line
      puts '[TEST PASSED] : All attributes are well formed'
      return true
    end
    puts "[ERROR] line #{ln} : No well formed Attribute"
    false
  end

  def single_node?(line)
    if /^<\/?[A-Za-z]+\s*>/ === line
      puts '[SINGLE NODE]'
      return true
    end
    # puts 'NOT A SINGLE NODE'"[ERROR] line #{ln} : No well formed Attribute"
    false
  end

  def check_closing_tag_inline(line, ln)
    node_name = get_node_name(line)
    node_name_last = get_node_name_last(line)
    if node_name == node_name_last
      puts '[TEST PASSED] Matching closing backet'
    else
      puts "[ERROR] line #{ln} : No matching closing bracket"
    end
  end

  def attributes?(line)
    if /^\s*<[A-Za-z]+\s+.+>$/ === line
      return true
    end
    false
  end

  def get_node_name(line)
    line[/^\s*<\s*([A-Za-z]+).*/, 1]
  end

  def get_node_name_last(line)
    line[/<\s*\/\s*([A-Za-z]+).*/, 1]
  end

  def add_node_to_buffer(line, ln)
    @multi_line_buffer << get_node_name(line)
    @root ||= get_node_name(line)
    puts "[CRITICAL ERROR] line #{ln} : Only one root is allowed" if @root_closed
  end

  def remove_node_to_buffer(line)
    @multi_line_buffer.delete(get_node_name_last(line))
    if get_node_name_last(line) == @root
      @root_closed = true
      @root_count += 1
    end
  end

  def adm_multi_line_node(line, ln)
    if get_node_name(line) && get_node_name(line) != ''
      add_node_to_buffer(line, ln)
    elsif get_node_name_last(line) && get_node_name_last(line) != ''
      remove_node_to_buffer(line)
    end
  end

  def validate_root
    puts "[CRITICAL ERROR] File needs to have 1 root node" if @root_count != 1
    puts "[CRITICAL ERROR] Closing tag missing for root node" unless @root_closed
  end

  def validate
    prolog_at_start?

    1.upto(@input.length - 1) do |i|
      line = @input[i]
      puts line
      if single_node?(line)
        adm_multi_line_node(line, i)
      else
        check_closing_tag_inline(line,i)
        well_formed_attributes?(line,i) if attributes?(line)
      end
    end
    p @multi_line_buffer
    validate_root
  end
end
