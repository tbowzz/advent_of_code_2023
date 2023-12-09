class Day04
  def self.run(test: false)
    if test
      file = 'day_04_test_input.txt'
    else
      file = 'day_04_input.txt'
    end
    self.new.run(file: file)
  end

  # separated by a vertical bar (|):
  # a list of winning numbers
  # and then a list of numbers you have
  # you have to figure out which of the numbers
  # you have appear in the list of winning numbers.
  # The first match makes the card worth one point and each match
  # after the first doubles the point value of that card.

  def run(file:)
    text = File.open(file).read
    data = text.each_line.map { |line| line.strip }
    puts "Part 1: #{part_one(data)}"


    puts "Part 2: #{part_two(data)}"
  end

  # Card 1 has four matching numbers, so you win one copy each of the next four cards: cards 2, 3, 4, and 5.
  # Your original card 2 has two matching numbers, so you win one copy each of cards 3 and 4.
  # Your copy of card 2 also wins one copy each of cards 3 and 4.
  # Your four instances of card 3 (one original and three copies) have two matching numbers, so you win four copies each of cards 4 and 5.
  # Your eight instances of card 4 (one original and seven copies) have one matching number, so you win eight copies of card 5.
  # Your fourteen instances of card 5 (one original and thirteen copies) have no matching numbers and win no more cards.
  # Your one instance of card 6 (one original) has no matching numbers and wins no more cards.

  # Card 2 has two winning numbers (32 and 61), so it is worth 2 points.
  # Card 3 has two winning numbers (1 and 21), so it is worth 2 points.
  # Card 4 has one winning number (84), so it is worth 1 point.
  # Card 5 has no winning numbers, so it is worth no points.
  # Card 6 has no winning numbers, so it is worth no points.

  # Once all of the originals and copies have been processed,
  # you end up with
  # 1 instance of card 1,
  # 2 instances of card 2,
  # 4 instances of card 3,
  # 8 instances of card 4,
  # 14 instances of card 5,
  # and 1 instance of card 6.
  # In total, this example pile of scratchcards causes you to ultimately have 30 scratchcards!

  def part_two(data)
    cards = data.map { |d| d.split(':').last }
    card_instances = Hash.new
    cards.count.times { |c| card_instances[c] = 1 }
    card_row = 0
    loop do
      card = cards[card_row]
      break if card.nil?
      card_instances[card_row].times do |instance|
        wins = calc_wins(card)
        break if wins == 0
        wins.times do |w|
          card_instances[card_row + w + 1] += 1
        end
      end
      card_row += 1
    end
    card_instances.values.sum
  end

  def part_one(data)
    sum = 0
    cards = data.map { |d| d.split(':').last }
    cards.each do |card|
      wins = calc_wins(card)
      sum += (2**(wins - 1)).floor
    end
    sum
  end

  def calc_wins(card)
    cols = card.split('|')
    winning_numbers = cols[0].split(' ')
    my_numbers = cols[1].split(' ')
    my_numbers.count { |n| winning_numbers.include?(n) }
  end
end

# Day04.run(test: true)
Day04.run(test: false)

