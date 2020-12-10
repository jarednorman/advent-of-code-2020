module AoC::Year2020::Day9
  class Part1
    def initialize(input = real_input, size = 25)
      @size = size
      @input = input.split("\n").map(&:to_i)
    end

    def solution
      input.each_cons(@size + 1) do |x|
        num = x.last
        cands = x[0..@size - 1]

        return num unless cands.combination(2).any?{|z|z.sum == num}
      end
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day9.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 127, Part1.new(<<~INPUT, 5).solution
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      INPUT
    end

    def test_real_input
      assert_equal 1504371145, Part1.new().solution
    end
  end

  class Part2 < Part1
    def solution
      sum = super

      (0..input.length - 1).each do |start|
        (start + 1..input.length - 1).each do |finish|
          range = input[start..finish]
          if range.sum == sum
            return range.sort.first + range.sort.last
          end
        end
      end
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 62, Part2.new(<<~INPUT, 5).solution
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      INPUT
    end
  end
end

