module AoC::Year2020::Day21
  Food = Struct.new(:ingredients, :allergens) do
  end

  class Parser
    def initialize(input)
      @input = input
    end

    def parse
      input.split("\n").map do |line|
        m = /(.*) \(contains (.*)\)/.match(line)

        Food.new(
          m[1].split(" "),
          m[2].split(", ")
        )
      end
    end

    private

    attr_reader :input
  end

  class ParserTest < Minitest::Test
    def test_parsing_example
      input = <<~INPUT
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
      INPUT

      assert_equal(
        [
          Food.new(%w(mxmxvkd kfcds sqjhc nhms), %w(dairy fish)),
          Food.new(%w(trh fvjkl sbzzf mxmxvkd), %w(dairy)),
          Food.new(%w(sqjhc fvjkl), %w(soy)),
          Food.new(%w(sqjhc mxmxvkd sbzzf), %w(fish))
        ],
        Parser.new(input).parse
      )
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.new(input).parse
    end

    def solution
      allergens = input.flat_map(&:allergens).uniq
      unsafe_ingredients = allergens.flat_map do |a|
        input.select{|f|f.allergens.include? a}.map(&:ingredients).inject(&:&)
      end.uniq

      input.sum { |f| (f.ingredients - unsafe_ingredients).length }
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day21.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 5, Part1.new(<<~INPUT).solution
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
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

