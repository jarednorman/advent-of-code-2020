module AoC::Year2020::Day6
  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      input.split("\n\n").map do |group|
        group.split("\n").flat_map(&:chars).to_set.length
      end.sum
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day6.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 11, Part1.new(<<~INPUT).solution
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
      INPUT
    end
  end

  class Part2 < Part1
    def solution
      input.split("\n\n").map do |group|
        lines = group.split("\n")
        qs = lines.flat_map(&:chars).to_set
        num_people = lines.length
        all = lines.flat_map(&:chars)

        qs.select do |q|
          all.count(q) == num_people
        end.length
      end.sum
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 6, Part2.new(<<~INPUT).solution
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
      INPUT
    end
  end
end

