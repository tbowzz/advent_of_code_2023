class Day07
  def self.run(test: false)
    file = "day_07_#{test ? 'test_' : ''}input.txt"
    self.new.run(file: file)
  end

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }

    puts "Part 1: #{part_one(data)}"
    puts "Part 2: #{part_two(data)}"
  end

  def part_two(data)
    solve(data, 'J')
  end

  def part_one(data)
    solve(data)
  end

  def solve(data, joker = nil)
    hands = data.map { |line| line.split(' ') }
    cards = hands.map { |hand| hand[0] }
    ranked_cards = cards.sort do |a_cards, b_cards|
      result = hand_val(a_cards, joker) <=> hand_val(b_cards, joker)
      if result.nil? || result.zero?
        5.times do |i|
          result = compare_cards(a_cards[i], b_cards[i], joker)
          break if result != 0
        end
      end
      result
    end
    sum = 0
    ranked_cards.reverse.each_with_index do |cards, i|
      score = hands.detect { |hand| hand[0] == cards }.last
      sum += score.to_i * (i + 1)
    end
    sum
  end

  def compare_cards(a, b, joker)
    values = %w[A K Q J T 9 8 7 6 5 4 3 2]
    if joker
      values.delete(joker)
      values << joker
    end
    values.index(a) <=> values.index(b)
  end

  def hand_val(hand, joker = nil)
    return 1 if is_five_of_a_kind(hand, joker)
    return 2 if is_four_of_a_kind(hand, joker)
    return 3 if is_full_house(hand, joker)
    return 4 if is_three_of_a_kind(hand, joker)
    return 5 if is_two_pair(hand, joker)
    return 6 if is_one_pair(hand, joker)
    return 7 if is_high_card(hand, joker)
  end

  def is_high_card(hand, joker = nil)
    hand.chars.uniq.length == hand.length
  end

  def is_one_pair(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.uniq.length == hand.length - 1
    else
      tallied = hand.chars.tally
      joker_count = tallied[joker]
      tallied.delete(joker)
      tallied.values.count { |t| joker_count + t == 2 } >= 1
    end
  end

  def is_two_pair(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.tally.values.sort == [1, 2, 2]
    else
      tallied = hand.chars.tally
      joker_count = tallied[joker]
      tallied.delete(joker)
      tallied.values.count { |t| joker_count + t == 2 } == 2
    end
  end

  def is_three_of_a_kind(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.tally.values.sort == [1, 1, 3]
    else
      tallied = hand.chars.tally
      joker_count = tallied[joker]
      tallied.delete(joker)
      tallied.values.any? { |t| joker_count + t == 3 }
    end
  end

  def is_full_house(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.tally.values.sort == [2, 3]
    else
      tallied = hand.chars.tally
      return false if tallied.keys.count != 3
      joker_count = tallied[joker]
      tallied.delete(joker)
      tallied.values.any? { |t| joker_count + t == 3 || joker_count + t == 2 }
    end
  end

  def is_four_of_a_kind(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.tally.values.sort == [1, 4]
    else
      tallied = hand.chars.tally
      joker_count = tallied[joker]
      tallied.delete(joker)
      tallied.values.any? { |t| joker_count + t == 4 }
    end
  end

  def is_five_of_a_kind(hand, joker = nil)
    if !joker || !hand.chars.include?(joker)
      hand.chars.uniq.length == 1
    else
      tallied = hand.chars.tally
      joker_count = tallied[joker]
      tallied.delete(joker)
      hand == "JJJJJ" || tallied.values.any? { |t| joker_count + t == 5 }
    end
  end
end

# Day07.run(test: true)
Day07.run(test: false)
