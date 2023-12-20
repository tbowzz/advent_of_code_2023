class Day10
  def self.run(test: false)
    if test
      cases = [
        ".....
         .S-7.
         .|.|.
         .L-J.
         .....",
        "-L|F7
         7S-7|
         L|7||
         -L-J|
         L|-JF",
        "..F7.
         .FJ|.
         SJ.L7
         |F--J
         LJ...",
        "7-F7-
         .FJ|7
         SJLL7
         |F--J
         LJ.LJ",
        ".....
         .S-7.
         .|.|.
         .L-J.
         ....."
      ]
      cases.each do |c|
        data = c.split("\n").map(&:strip).map(&:chars)
        self.new.run(data: data)
      end
    else
      file = "day_10_input.txt"
      text = File.open(file).read
      data = text.each_line.map(&:strip).map(&:chars)
      self.new.run(data: data)
    end
  end

  def run(data:)
    puts "Part 1: #{part_one(data).length / 2}"
    puts "Part 2: #{part_two(data)}"
  end

  def part_two(data)
  end

  # | is a vertical pipe connecting north and south.
  # - is a horizontal pipe connecting east and west.
  # L is a 90-degree bend connecting north and east.
  # J is a 90-degree bend connecting north and west.
  # 7 is a 90-degree bend connecting south and west.
  # F is a 90-degree bend connecting south and east.
  # . is ground; there is no pipe in this tile.
  # S is the starting position of the animal; there is a pipe on this tile,
  # but your sketch doesn't show what shape the pipe has.

  def part_one(grid)
    animal_row = nil
    animal_col = nil
    grid.each_with_index do |row, y|
      row.each_with_index do |col, x|
        next unless grid[y][x] == "S"
        animal_row = y
        animal_col = x
        break
      end
      break unless animal_row.nil?
    end

    pos_r = prev_r = animal_row
    pos_c = prev_c = animal_col
    path = [[animal_row, animal_col]]
    done = false
    loop do
      pipe_type = grid[pos_r][pos_c]
      search_locations = get_search_locations(pipe_type, grid, pos_r, pos_c, prev_r, prev_c)
      search_locations.keys.each do |direction|
        search_pos_r, search_pos_c = search_locations[direction]
        next unless is_eligible_pipe?(direction, grid[search_pos_r][search_pos_c])

        if !path.include?([search_pos_r, search_pos_c])
          path << [search_pos_r, search_pos_c]
        else
          done = true
        end
        prev_r = pos_r
        prev_c = pos_c
        pos_r = search_pos_r
        pos_c = search_pos_c
        break
      end
      break if done
    end
    path
  end

  def is_eligible_pipe?(direction, val)
    case direction
    when :W
      %w[- L F S].include?(val)
    when :N
      %w[| F 7 S].include?(val)
    when :E
      %w[- J 7 S].include?(val)
    when :S
      %w[| L J S].include?(val)
    end
  end

  def get_search_locations(pipe_type, grid, pos_r, pos_c, prev_r, prev_c)
    locations = {}
    allowed_directions = get_allowed_directions(pipe_type)
    if pos_c - 1 >= 0 && prev_c != pos_c - 1 && allowed_directions.include?(:W)
      locations[:W] = [pos_r, pos_c - 1]
    end
    if pos_c + 1 <= grid[0].length && prev_c != pos_c + 1 && allowed_directions.include?(:E)
      locations[:E] = [pos_r, pos_c + 1]
    end
    if pos_r - 1 >= 0 && prev_r != pos_r - 1 && allowed_directions.include?(:N)
      locations[:N] = [pos_r - 1, pos_c]
    end
    if pos_r + 1 <= grid.length && prev_r != pos_r + 1 && allowed_directions.include?(:S)
      locations[:S] = [pos_r + 1, pos_c]
    end
    locations
  end

  def get_allowed_directions(pipe_type)
    return [:W, :E, :N, :S] if pipe_type == 'S'
    return [:N, :S] if pipe_type == '|'
    return [:W, :E] if pipe_type == '-'
    return [:N, :E] if pipe_type == 'L'
    return [:N, :W] if pipe_type == 'J'
    return [:S, :W] if pipe_type == '7'
    return [:S, :E] if pipe_type == 'F'
  end
end

# Day10.run(test: true)
Day10.run(test: false)

