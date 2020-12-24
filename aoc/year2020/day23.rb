module AoC::Year2020::Day23
  class Game
    def initialize(input)
      @cups = input
      @current = cups[0]
      @min = cups.min
      @max = cups.max
    end

    def step!
      picked_up = take_three
      self.cups -= picked_up
      destination_cup = determine_next
      di = cups.find_index(destination_cup) + 1
      self.cups.insert(di, *picked_up)

      self.current = cups[(cups.find_index(current) + 1) % cups.length]
    end

    attr_accessor :current, :cups

    private

    def determine_next
      cup = current
      loop do
        cup -= 1
        cup = @max if cup < @min
        return cup if cups.find_index(cup)
      end
    end

    def take_three
      (cups * 2)[current_index + 1..current_index + 3]
    end

    def current_index
      @cups.find_index current
    end
  end

  class GameTest < Minitest::Test
    def test_example
      g = Game.new([3, 8, 9, 1, 2, 5, 4, 6, 7])

      g.step!

      assert_equal([3, 2, 8, 9, 1, 5, 4, 6, 7], g.cups)
      assert_equal(2, g.current)

      9.times { g.step! }

      assert_equal([5, 8, 3, 7, 4, 1, 9, 2, 6], g.cups)
      assert_equal(8, g.current)

      g = Game.new([3, 8, 9, 1, 2, 5, 4, 6, 7])
      100.times { g.step! }

      # assert_equal([5, 8, 3, 7, 4, 1, 9, 2, 6], g.cups)
      # assert_equal(8, g.current)
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input.strip.chars.map(&:to_i)
    end

    def solution
      game = Game.new(input)
      100.times { game.step! }
      cups = game.cups
      one_index = cups.find_index(1)
      (cups[one_index + 1..-1] + cups[0..one_index - 1]).join
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day23.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part1.new(<<~INPUT).solution
      INPUT
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part2.new(<<~INPUT).solution
      INPUT
    end
  end
end

