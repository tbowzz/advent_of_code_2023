class Day06
  def self.run(test: false)
    if test
      file = 'day_06_test_input.txt'
    else
      file = 'day_06_input.txt'
    end
    self.new.run(file: file)
  end

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }

    puts "Part 1: #{part_one(data)}"
    puts "Part 2: #{part_two(data)}"
  end

  # To see how much margin of error you have,
  # determine the number of ways you can beat the record in each race;
  # in this example, if you multiply these values together,
  # you get 288 (4 * 8 * 9).

  def part_two(data)
    time = data[0].split(':').last.gsub(' ', '').to_i
    distance = data[1].split(':').last.gsub(' ', '').to_i
    races = [[time, distance]]
    race(races)
  end

  def part_one(data)
    times = data[0].split(':').last.split.map(&:to_i)
    distances = data[1].split(':').last.split.map(&:to_i)
    races = []
    times.each_with_index { |t, i| races << [t, distances[i]] }
    race(races)
  end

  def race(races)
    ways_to_win = []
    races.each do |r|
      ways = 0
      (0..r[0]).each do |hold_time|
        move_time = r[0] - hold_time
        distance = hold_time * move_time
        ways += 1 if distance > r[1]
      end
      ways_to_win << ways
    end
    ways_to_win.reduce(:*)
  end
end

# Day06.run(test: true)
Day06.run(test: false)

