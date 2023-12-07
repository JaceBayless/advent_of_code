require "../../helpers"

class CamelCardsHand
  attr_accessor :hand, :bid

  CARDS_ORDERED_BY_POWER = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

  def initialize(hand:, bid:)
    @hand = hand
    @bid = bid.to_i
  end

  def tallied_hand
    @tallied_hand ||= @hand.chars.tally.sort_by { _2 }.reverse
  end

  def compare(cch2)
    tallied_hand.length.times do |i|
      a = tallied_hand[i][1]
      b = cch2.tallied_hand[i][1]
      return a > b ? 1 : 0 if a != b
    end

    hand.length.times do |i|
      a = hand[i]
      b = cch2.hand[i]
      return CARDS_ORDERED_BY_POWER.index(a) < CARDS_ORDERED_BY_POWER.index(b) ? 1 : 0 if a != b
    end
  end
end

hands = load_data("data.txt", splits: ["\n", " "], cast_method: :to_s).map do |hand, bid|
  CamelCardsHand.new(hand: hand, bid: bid)
end

ans = 0
hands.sort(&:compare).each_with_index do |hand, index|
  ans += hand.bid * (index + 1)
end

puts ans
