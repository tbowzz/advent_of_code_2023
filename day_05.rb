class Day05
  def self.run(test: false)
    if test
      file = 'day_05_test_input.txt'
    else
      file = 'day_05_input.txt'
    end
    self.new.run(file: file)
  end

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }

    puts "Part 1: #{part_one(data)}"
    puts "Part 2: #{part_two(data)}"
  end

  def part_two(data)
    raw_seeds = data[0].split(':').last.split(' ').map(&:to_i)
    seed_ranges = part_two_seed_ranges(raw_seeds)
    map_ranges = build_map_ranges(data)
    location = 0
    loop do
      potential_seed = reverse_lookup(location, map_ranges)
      seed_ranges.each do |range|
        return location if range.include?(potential_seed)
      end
      location += 1
    end
    0
  end

  def reverse_lookup(location, map_ranges)
    src = location
    map_ranges.reverse_each do |map|
      map.each do |src_range, dst_range|
        if dst_range.include?(src)
          src = src_range.first + (src - dst_range.first)
          break
        end
      end
    end
    src
  end

  def build_map_ranges(data)
    maps = []
    map = {}
    data[1..-1].each do |line|
      next if line == ''

      if line.include?('map:')
        maps << map if map.length.positive?
        map = {}
      else
        dest, src, length = line.split(' ').map(&:to_i)
        map[(src..(src + length - 1))] = (dest..(dest + length - 1))
      end
    end
    maps << map if map.keys.length.positive?
    maps
  end

  def part_two_seed_ranges(raw_seeds)
    ranges = []
    index = 0
    loop do
      break if raw_seeds[index].nil?
      seed_start = raw_seeds[index].to_i
      seed_end = seed_start + raw_seeds[index + 1].to_i - 1
      ranges << (seed_start..seed_end)
      index += 2
    end
    ranges
  end

  # seed-to-soil map:
  # 50 98 2  => dest, src, count
  # 52 50 48 => dest, src, count
  # unmapped values are equivalent to the src value => So, seed number 10 corresponds to soil number 10.

  # Seed number 79 corresponds to soil number 81.
  # Seed number 14 corresponds to soil number 14.
  # Seed number 55 corresponds to soil number 57.
  # Seed number 13 corresponds to soil number 13.
  # Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
  # Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
  # Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
  # Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
  #So, the lowest location number in this example is 35.
  #
  # What is the lowest location number that corresponds to any of the initial seed numbers?

  def part_one(data)
    seeds = data[0].split(':').last.split(' ').map(&:to_i)
    maps = build_maps_part_one(data)
    find_min_dest(seeds, maps)
  end

  def build_maps_part_one(data)
    maps = []
    map = []
    data[1..-1].each do |line|
      next if line == ''

      if line.include?('map:')
        maps << map if map.length.positive?
        map = []
      else
        map << line.split(' ').map(&:to_i)
      end
    end
    maps << map if map.length.positive?
    maps
  end

  def find_min_dest(seeds, maps)
    min_dest = 10**9942067
    seeds.each do |seed|
      dest = seed
      maps.each do |map|
        mapper = map.detect { |m| dest >= m[1] && dest < m[1] + m[2] }
        dest = dest + mapper[0] - mapper[1] unless mapper.nil?
      end
      min_dest = dest if dest < min_dest
    end
    min_dest
  end
end

# Day05.run(test: true)
Day05.run(test: false)

