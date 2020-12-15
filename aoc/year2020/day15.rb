module AoC::Year2020::Day15
  class Game
    include Enumerable

    def initialize(seed)
      @seed = seed
      @a = []
    end

    def each(&block)
      return to_enum(:each) unless block_given?

      while seed.any?
        a << seed.shift
        block.call(a.last)
      end

      loop do
        if a.count(a.last) == 1
          a << 0
          block.call(a.last)
        else
          y = a.each_with_index.to_a.reverse.select { |x, i| x == a.last }.take(2).map(&:last).inject(&:-)
          a << y
          block.call(a.last)
        end
      end
    end

    private

    attr_reader :a, :seed
  end

  class GameTest < Minitest::Test
    def test_sample_inputs
      g = Game.new([0, 3, 6])

      assert_equal [0, 3, 6], g.take(3)
      assert_equal [0, 3, 3, 1, 0, 4, 0], g.take(7)

      g = Game.new([0, 3, 6])
      assert_equal 436, g.take(2020).last
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input.split(",").map(&:to_i)
    end

    def solution
      g = Game.new(input)
      g.take(2020).last
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day15.txt")
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

