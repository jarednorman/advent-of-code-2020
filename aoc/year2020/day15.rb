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
      g = game_class.new(input)
      g.take(num).last
    end

    private

    def game_class
      Game
    end

    def num
      2020
    end

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day15.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 1, Part1.new(<<~INPUT).solution
        1,3,2
      INPUT
    end
  end

  class Game2
    include Enumerable

    def initialize(seed)
      @seed = seed
      @seen = {}
      @index = -1
      @last = nil
    end

    def each(&block)
      return to_enum(:each) unless block_given?

      while seed.any?
        do_number seed.shift, block
      end

      loop do
        if seen[last].length < 2
          do_number 0, block
        else
          y = seen[last].last(2).reverse.inject(&:-)
          do_number y, block
        end
      end
    end

    private

    attr_reader :seen, :seed, :index, :last

    def do_number n, block
      @index += 1
      seen[n] ||= []
      seen[n] << index
      block.call(n)
      @last = n
    end
  end

  class Game2Test < Minitest::Test
    def test_sample_inputs
      g = Game2.new([0, 3, 6])

      assert_equal [0, 3, 6], g.take(3)
      assert_equal [0, 3, 3, 1, 0, 4, 0], g.take(7)

      g = Game2.new([0, 3, 6])
      assert_equal 436, g.take(2020).last
    end
  end

  class Part2 < Part1
    def game_class
      Game2
    end

    def num
      30_000_000
    end
  end

  class Part2Test < Minitest::Test
    def xtest_sample_input
      assert_equal 175594, Part2.new(<<~INPUT).solution
        0,3,6
      INPUT
    end
  end
end

