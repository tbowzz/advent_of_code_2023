class Day02
  def self.run(test: false)
    if test
      file = 'day_02_test_input.txt'
    else
      file = 'day_02_input.txt'
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
    data = data.drop(1)
    sum = 0
    data.each do |game|
      pulls = game.split(":")[1].split(/[,;]/).map(&:strip)
      max_red = max_green = max_blue = 0
      pulls.each do |pull|
        val, key = pull.split(" ")
        max_red = val.to_i if key == "red" && val.to_i > max_red
        max_green = val.to_i if key == "green" && val.to_i > max_green
        max_blue = val.to_i if key == "blue" && val.to_i > max_blue
      end
      sum += max_red * max_green * max_blue
    end
    sum
  end

  def part_one(data)
    # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    config = data.first
    maxes = parse_config(config)
    data = data.drop(1)
    sum = 0
    data.each do |game|
      game_data = game.split(":")
      game_id = game_data[0].split(" ")[1].to_i
      pulls = game_data[1].split(/[,;]/).map(&:strip)
      next if pulls.any? { |pull| val, key = pull.split(" "); val.to_i > maxes[key] }
      sum += game_id
    end
    sum
  end

  def parse_config(config)
    raw_maxes = config.split(":")[1].split(",")
    maxes = Hash.new
    raw_maxes.each do |max|
      val, key = max.split(" ")
      maxes[key] = val.to_i
    end
    maxes
  end
end

# Day02.run(test: true)
Day02.run(test: false)

# The Elf would first like to know which games would have been possible
# if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
# Determine which games would have been possible if the bag had been loaded with only
# 12 red cubes, 13 green cubes, and 14 blue cubes.
# What is the sum of the IDs of those [possible] games?
