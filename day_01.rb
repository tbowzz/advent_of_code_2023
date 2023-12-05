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

    puts "Part 1: #{}"


    puts "Part 2: #{}"
  end
end

Day01.run(test: true)
# Day01.run(test: false)

