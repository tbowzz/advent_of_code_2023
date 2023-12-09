class Day03
  def self.run(test: false)
    if test
      file = 'day_03_test_input.txt'
    else
      file = 'day_03_input.txt'
    end
    self.new.run(file: file)
  end

  # any number adjacent to a symbol, even diagonally, is a "part number"
  #In this schematic, two numbers are not part numbers because they are not
  # adjacent to a symbol: 114 (top right) and 58 (middle right).
  # Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
  # What is the sum of all of the part numbers in the engine schematic?

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }

    sum = part_one data
    puts "Part 1: #{sum}"


    sum = part_two data
    puts "Part 2: #{sum}"
  end

  def part_two(data)
    data = data.map(&:chars)
    sum = 0
    numbers = []
    data.each_with_index do |line, row_index|
      running_number = ""
      running_number_locations = []
      line.each_with_index do |char, col_index|
        if char.match?(/[[:digit:]]/)
          running_number += char
          running_number_locations << [row_index, col_index]
          if running_number != "" && col_index == line.length - 1
            numbers << running_number_locations
            running_number_locations = []
          end
        elsif !char.match?(/[[:digit:]]/) || col_index == line.length - 1
          if running_number != ""
            numbers << running_number_locations
            running_number_locations = []
          end
          running_number = ""
        end
      end
    end

    data.each_with_index do |line, row_index|
      line.each_with_index do |char, col_index|
        touching_numbers = []
        if is_gear?(char)
          check_locations = check_locations(row_index, col_index, line)
          check_locations.each do |check_location|
            if is_num?(data[check_location[0]][check_location[1]])
              option = numbers.detect do |locations|
                locations.include?(check_location)
              end
              touching_numbers << option if !option.nil? && !touching_numbers.include?(option)
            end
          end
          if touching_numbers.length == 2
            sum += touching_numbers.map { |loc| loc.map { |pos| data[pos[0]][pos[1]] }.join('').to_i }.inject(:*)
          end
        end
      end
    end
    sum
  end

  def check_locations(row_index, col_index, line)
    locations = []
    locations << [row_index - 1, col_index - 1] if row_index - 1 >= 0 && col_index - 1 >= 0
    locations << [row_index - 1, col_index] if row_index - 1 >= 0
    locations << [row_index - 1, col_index + 1] if row_index - 1 >= 0 && col_index + 1 < line.length
    locations << [row_index, col_index - 1] if col_index - 1 >= 0
    locations << [row_index, col_index + 1] if col_index + 1 < line.length
    locations << [row_index + 1, col_index - 1] if row_index + 1 < line.length && col_index - 1 >= 0
    locations << [row_index + 1, col_index] if row_index + 1 < line.length
    locations << [row_index + 1, col_index + 1] if row_index + 1 < line.length && col_index + 1 < line.length
    locations
  end

  def part_one(data)
    sum = 0
    data.each_with_index do |line, row_index|
      running_number = ""
      found = false
      line.split('').each_with_index do |char, col_index|
        if char.match?(/[[:digit:]]/)
          running_number += char
          if (is_sym?(data[row_index - 1][col_index - 1]) && row_index - 1 >= 0 && col_index - 1 >= 0) ||
             (is_sym?(data[row_index - 1][col_index]) && row_index - 1 >= 0) ||
             (is_sym?(data[row_index - 1][col_index + 1]) && row_index - 1 >= 0) ||
             (is_sym?(data[row_index][col_index - 1]) && col_index - 1 >= 0) ||
             (is_sym?(data[row_index][col_index + 1])) ||
             (row_index + 1 < line.length && is_sym?(data[row_index + 1][col_index - 1]) && col_index - 1 >= 0) ||
             (row_index + 1 < line.length && is_sym?(data[row_index + 1][col_index])) ||
             (row_index + 1 < line.length && is_sym?(data[row_index + 1][col_index + 1]))
            found = true
          end
          if found && running_number != "" && col_index == line.length - 1
            sum += running_number.to_i
          end
        elsif !char.match?(/[[:digit:]]/) || col_index == line.length - 1
          if running_number != "" && found
            sum += running_number.to_i
          end
          found = false
          running_number = ""
        end
      end
    end
    sum
  end

  def is_gear?(char)
    return false if char.nil? || char == false
    char == '*'
  end

  def is_num?(char)
    return false if char.nil? || char == false
    char.match?(/[[:digit:]]/)
  end

  def is_sym?(char)
    return false if char.nil? || char == false
    !char.match?(/[[:digit:]]/) && char != '.'
  end
end

# Day03.run(test: true)
Day03.run(test: false) # 30798757 part 2 is too low, 83245878 part 2 also too low

