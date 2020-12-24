module AoC::Year2020::Day23
  class Game
    def initialize(input)
      @nodes = {}
      @current = [input.shift, nil]
      prev_node = @current
      @nodes[prev_node.first] = prev_node

      input.each do |id|
        new_node = [id, nil]
        prev_node[1] = new_node
        prev_node = new_node
        @nodes[prev_node.first] = prev_node
      end

      prev_node[1] = @current

      @min = @nodes.keys.min
      @max = @nodes.keys.max
    end

    def step!
      picked_up = @current.last
      @current[1] = picked_up.last.last.last

      in_hand_cup_ids = [picked_up.first, picked_up.last.first, picked_up.last.last.first]

      target = @current.first
      loop do
        target -= 1
        target = @max if target < @min

        break unless in_hand_cup_ids.include?(target)
      end

      picked_up.last.last[1] = @nodes[target].last
      @nodes[target][1] = picked_up

      @current = @current.last
    end

    def current
      @current.first
    end

    def cups
      @nodes[1]
    end

    private
  end

  class GameTest < Minitest::Test
    def test_example
      g = Game.new([3, 8, 9, 1, 2, 5, 4, 6, 7])

      g.step!

      # assert_equal([3, 2, 8, 9, 1, 5, 4, 6, 7], g.cups)
      assert_equal(2, g.current)

      9.times { g.step! }

      # assert_equal([5, 8, 3, 7, 4, 1, 9, 2, 6], g.cups)
      assert_equal(8, g.current)

      g = Game.new([3, 8, 9, 1, 2, 5, 4, 6, 7])
      100.times { g.step! }
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input.strip.chars.map(&:to_i)
    end

    def solution
      game = new_game
      n.times.each { |n| game.step!  }
      result game
    end

    private

    attr_reader :input

    def result game
      cups = game.cups
      current = cups.last
      str = ""
      until current == cups
        str << current.first.to_s
        current = current.last
      end
      str
    end

    def new_game
      Game.new(input)
    end

    def n
      100
    end

    def real_input
      @input ||= File.read("aoc/year2020/day23.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal "67384529", Part1.new(<<~INPUT).solution
        389125467
      INPUT
    end
  end

  class Part2 < Part1
    def new_game
      Game.new(input + (input.max + 1..1_000_000).to_a)
    end

    def n
      10_000_000
    end

    def result(game)
      one = game.cups
      one.last.first * one.last.last.first
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 149245887792, Part2.new(<<~INPUT).solution
        389125467
      INPUT
    end
  end
end

