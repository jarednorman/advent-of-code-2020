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
      input.sum { |f| (f.ingredients - unsafe_ingredients).length }
    end

    private

    def allergens
      @allergens ||= input.flat_map(&:allergens).uniq
    end

    def unsafe_ingredients
      @unsafe_ingredients ||= allergens.flat_map do |a|
        input.select{|f|f.allergens.include? a}.map(&:ingredients).inject(&:&)
      end.uniq
    end

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
      u = allergens.map do |a|
        [a, input.select{|f|f.allergens.include? a}.map(&:ingredients).inject(&:&)]
      end.to_h

      bad = []

      until u.empty?
        allergen, foods= *u.find {|allergen, foods| foods.length == 1 }
        food = foods.first

        u.delete(allergen)

        u.transform_values! { |v|
          v.reject { |f| f == food }
        }

        bad << [allergen, food]
      end

      bad.sort_by(&:first).map(&:last).join(",")
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal "mxmxvkd,sqjhc,fvjkl", Part2.new(<<~INPUT).solution
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
      INPUT
    end
  end
end

