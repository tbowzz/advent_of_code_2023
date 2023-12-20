class Day08
  def self.run(test: false)
    file = "day_08_#{test ? 'test_' : ''}input.txt"
    self.new.run(file: file)
  end

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }

    puts "Part 1: #{part_one(data)}"
    puts "Part 2: #{part_two(data)}"
  end

  def part_two(data)
    part_one(data)
  end

  def part_one(data)
    instructions = data.shift.chars.map(&:to_sym)
    data.shift
    nodules = {}
    data.each do |datum|
      node, children = datum.split('=').map { |val| val.gsub(/\s|\(|\)/, '') }
      left, right = children.split(',')
      nodules[node] = {
        'L': left,
        'R': right
      }
    end
    position = 'AAA'
    steps = 0
    instruction_index = 0
    loop do
      node = nodules[position]
      position = node[instructions[instruction_index % instructions.length]]
      steps += 1
      break if position == 'ZZZ'

      instruction_index += 1
    end
    steps
  end
end

Day08.run(test: true)
# Day08.run(test: false)

