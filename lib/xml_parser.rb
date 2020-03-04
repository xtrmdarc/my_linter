require 'colorize'

class XmlParser
  def initialize(input)
    @input = input
    @multi_line_buffer = []
    @root_count = 0
    @root_closed = false
    @root = nil
  end

  private

  def check_closing_tag_inline(line, line_number)
    node_name = get_node_name(line)
    node_name_last = get_node_name_last(line)
    if node_name == node_name_last
      puts '[TEST PASSED] : '.green + 'Matching closing bracket'
    else
      puts '[CRITICAL ERROR] : '.red + "line #{line_number} : No matching closing bracket"
    end
  end

  def validate_multilineal
    puts '[CRITICAL ERROR] : '.red + 'File needs to have 1 root node' if @root_count != 1
    puts '[CRITICAL ERROR] : '.red + 'Closing tag missing for root node' unless @root_closed
    puts '[CRITICAL ERROR] : '.red + "Open node on #{@multi_line_buffer}" unless @multi_line_buffer.empty?
  end

  def adm_multi_line_node(line, line_number)
    if get_node_name(line) && get_node_name(line) != ''
      add_node_to_buffer(line, line_number)
    elsif get_node_name_last(line) && get_node_name_last(line) != ''
      remove_node_to_buffer(line)
    end
  end

  public

  def prolog_at_start?
    puts @input[0]
    if /^<\?xml(\s*[a-z]*=\".*\"\s*)*\?>$/ === @input[0]
      puts '[TEST PASSED] : '.green + 'Prolog found'
      return true
    end
    puts '[WARNING] : '.yellow + 'No well formed prolog at the start of the file'
    false
  end

  def well_formed_node?(line, line_number)
    if /^\s*<\s*\/?\s*[A-Za-z]\s*.*>$/ === line
      puts '[TEST PASSED] : '.green + 'Recognizable node structure'
      true
    else
      puts '[ERROR] : '.red + " line #{line_number} : Unrecognizable node structure"
      false
    end
  end

  def well_formed_attributes?(line, line_number)
    if /([A-Za-z]+=\".+\")+/ === line
      puts '[TEST PASSED] : '.green + 'All attributes are well formed'
      return true
    end
    puts '[ERROR] : '.red + " line #{line_number} : No well formed attribute"
    false
  end

  def single_node?(line)
    return true if /^\s*<\/?[A-Za-z]+\s*>$/ === line

    false
  end

  def attributes?(line)
    return true if /^\s*<[A-Za-z]+\s+.+>$/ === line

    false
  end

  def get_node_name(line)
    line[/^\s*<\s*([A-Za-z]+).*/, 1]
  end

  def get_node_name_last(line)
    line[/<\s*\/\s*([A-Za-z]+).*/, 1]
  end

  def add_node_to_buffer(line, line_number)
    @multi_line_buffer << get_node_name(line)
    @root ||= get_node_name(line)
    puts '[CRITICAL ERROR] : '.red + "line #{line_number} : Only one root is allowed" if @root_closed
  end

  def remove_node_to_buffer(line)
    @multi_line_buffer.delete(get_node_name_last(line))

    return unless get_node_name_last(line) == @root

    @root_closed = true
    @root_count += 1
  end

  def validate
    prolog_at_start?
    1.upto(@input.length - 1) do |i|
      line = @input[i]
      puts "line #{i + 1} : #{line}"
      if well_formed_node?(line, i + 1)
        if single_node?(line)
          adm_multi_line_node(line, i + 1)
        else
          check_closing_tag_inline(line, i + 1)
          well_formed_attributes?(line, i + 1) if attributes?(line)
        end
      end
    end
    validate_multilineal
  end
end
