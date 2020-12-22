module AoC::Year2020::Day22
  class Parser
    def initialize input, klass = Game
      @deck_1, @deck_2 = *input.split("\n\n")
      @klass = klass
    end

    def game
      @klass.new(
        Deck.new(@deck_1.split("\n")[1..-1].map(&:to_i)),
        Deck.new(@deck_2.split("\n")[1..-1].map(&:to_i)),
        {}
      )
    end
  end

  class ParserTest < Minitest::Test
    def test_example
      input = <<~INPUT
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
      INPUT

      assert_equal(
        Game.new(
          Deck.new([9, 2, 6, 3, 1]),
          Deck.new([5, 8, 4, 7, 10]),
          {}
        ),
        Parser.new(input).game
      )
    end
  end

  Deck = Struct.new(:cards) do
    def subdeck n
      Deck.new(cards[0..n - 1])
    end

    def draw
      [cards[0], Deck.new(cards[1..-1])]
    end

    def add new_cards
      Deck.new(cards + new_cards)
    end

    def empty?
      cards.empty?
    end

    def score
      cards.reverse.each_with_index.sum do |card, i|
        card * (i + 1)
      end
    end
  end

  class DeckTest < Minitest::Test
    def test_scoring
      deck = Deck.new([3, 2, 10, 6, 8, 5, 9, 4, 7, 1])
      assert_equal 306, deck.score
    end

    def test_adding_cards
      deck = Deck.new([9, 8, 7])
      deck = deck.add([1, 3])
      assert_equal Deck.new([9, 8, 7, 1, 3]), deck
    end

    def test_drawing_cards
      deck = Deck.new([9, 8, 7])
      card, deck = *deck.draw
      assert_equal 9, card
      assert_equal Deck.new([8, 7]), deck
    end
  end

  Game = Struct.new(:deck_one, :deck_two, :not_used) do
    def step
      card_one, d1 = *deck_one.draw
      card_two, d2 = *deck_two.draw

      if card_one > card_two
        d1 = d1.add([card_one, card_two])
      else
        d2 = d2.add([card_two, card_one])
      end

      Game.new(d1, d2, [])
    end

    def over?
      deck_one.empty? || deck_two.empty?
    end

    def winner
      return unless over?

      [deck_one, deck_two].find { |d| !d.empty? }
    end
  end

  class GameTest < Minitest::Test
    def test_over
      refute(Game.new(
        Deck.new([9, 2, 6, 3, 1]),
        Deck.new([5, 8, 4, 7, 10]),
        []
      ).over?)

      assert(Game.new(
        Deck.new([]),
        Deck.new([5, 8, 4, 7, 10]),
        []
      ).over?)

      assert(Game.new(
        Deck.new([5, 8, 4, 7, 10]),
        Deck.new([]),
        []
      ).over?)
    end

    def test_example
      game = Game.new(
        Deck.new([9, 2, 6, 3, 1]),
        Deck.new([5, 8, 4, 7, 10]),
        []
      )

      assert_equal(
        Game.new(
          Deck.new([2, 6, 3, 1, 9, 5]),
          Deck.new([8, 4, 7, 10]),
          []
        ),
        game.step
      )
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.new(input).game
    end

    def solution
      game = input

      game = game.step until game.over?

      game.winner.score
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day22.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 306, Part1.new(<<~INPUT).solution
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
      INPUT
    end
  end

  CACHE = Class.new do
    def [](g)
      @results ||= {}
      r = @results[[g.deck_one, g.deck_two]]
      if r
        puts "cache hit"
        return r
      end

      gx = g
      gx = gx.step until gx.over?

      @results[[g.deck_one, g.deck_two]] = gx
    end
  end.new

  Game2 = Struct.new(:deck_one, :deck_two, :previous_states, :p1_won) do
    def step
      if previous_states[[deck_one, deck_two]]
        return Game2.new(deck_one, deck_two, previous_states, true)
      end

      card_one, d1 = *deck_one.draw
      card_two, d2 = *deck_two.draw

      if d1.cards.length < card_one || d2.cards.length < card_two
        if card_one > card_two
          d1 = d1.add([card_one, card_two])
        else
          d2 = d2.add([card_two, card_one])
        end
      else
        sub_d1 = d1.subdeck(card_one)
        sub_d2 = d2.subdeck(card_two)
        sub_game = CACHE[Game2.new(sub_d1, sub_d2, {})]

        if sub_game.winner == sub_game.deck_one
          d1 = d1.add([card_one, card_two])
        else
          d2 = d2.add([card_two, card_one])
        end
      end

      Game2.new(d1, d2, {[deck_one, deck_two] => true}.merge(previous_states))
    end

    def over?
      p1_won || deck_one.empty? || deck_two.empty?
    end

    def winner
      return deck_one if p1_won
      return unless over?

      [deck_one, deck_two].find { |d| !d.empty? }
    end
  end

  class Game2Test < Minitest::Test
    def test_example
      g = Game2.new(
        Deck.new([9, 2, 6, 3, 1]),
        Deck.new([5, 8, 4, 7, 10]),
        {}
      )
    end
  end

  class Part2 < Part1
    def initialize(input = real_input)
      @input = Parser.new(input, Game2).game
    end

    def solution
      game = input

      game = CACHE[game]

      game.winner.score
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 291, Part2.new(<<~INPUT).solution
        Player 1:
        9
        2
        6
        3
        1

        Player 2:
        5
        8
        4
        7
        10
      INPUT
    end
  end
end

