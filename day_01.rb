class Day01
  def self.run(test: false)
    if test
      file = 'day_01_test_input.txt'
    else
      file = 'day_01_input.txt'
    end
    self.new.run(file: file)
  end

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }
    sum = part_one data
    puts "Part 1: #{sum}"
    sum = part_two data
    puts "Part 2: #{sum}"
  end

  def part_two(data)
    alpha_numbers = %w[one two three four five six seven eight nine]
    rows = []
    data.each do |datum|
      row_numbers = []
      datum.split('').each_with_index do |val, i|
        if val.match?(/[[:digit:]]/)
          row_numbers << val
        else
          substr = datum[i..-1]
          alpha_numbers.each_with_index do |alpha, j|
            loc = substr.index(alpha)
            row_numbers << "#{j + 1}" if !loc.nil? && loc == 0
          end
        end
      end
      rows << row_numbers
    end
    part_one(rows.map { |row| row.join('') })
  end

  def part_one(data)
    sum = 0
    data.each do |datum|
      numbers = datum.split('').select { |char| char.match?(/[[:digit:]]/) }
      val = "#{numbers.first}#{numbers.last}".to_i
      sum += val
    end
    sum
  end
end

# Day01.run(test: true)
Day01.run(test: false)

