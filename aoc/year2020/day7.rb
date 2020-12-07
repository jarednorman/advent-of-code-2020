module AoC::Year2020::Day7
  class Parser
    def initialize(input)
      @input = input
    end

    def parse
      @input.split("\n").each_with_object({}) do |line, output|
        _, bag_type, rules = */(.*) bags contain (.*)\./.match(line)
        output[bag_type] = {}

        if rules != "no other bags"
          rules.split(", ").each do |rule|
            _, num, type = */(\d) (.*) bags?/.match(rule).to_a

            output[bag_type][type] = num.to_i
          end
        end
      end
    end
  end

  class ParserTest < Minitest::Test
    def test_sample_input
      expected = {
        "light red" => {"bright white" => 1, "muted yellow" => 2},
        "dark orange" => { "bright white" => 3, "muted yellow" => 4 },
        "faded blue" => {}
      }
      assert_equal expected, Parser.new(<<~INPUT).parse
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        faded blue bags contain no other bags.
      INPUT
    end
  end

  class Transform1
    def initialize(rules)
      @rules = rules
    end

    def transform
      @rules.each_with_object(Hash.new {|h,k| h[k] = []}) do |(type, rules), result|
        rules.keys.each do |key, _value|
          result[key] << type
        end
      end
    end
  end

  class Transform1Test < Minitest::Test
    def test_sample_input
      expected = {
        "shiny gold" => ["light red", "dark orange"],
        "muted yellow" => ["dark orange"],
        "light red" => ["cool blue"]
      }
      assert_equal expected, Transform1.new({
        "light red" => {"shiny gold" => 1},
        "dark orange" => { "shiny gold" => 3, "muted yellow" => 4 },
        "muted yellow" => {},
        "cool blue" => {"light red" => 2}
      }).transform
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.new(input).parse
    end

    def solution
      @seen = []

      process("shiny gold")

      @seen.count
    end

    private

    attr_reader :input

    def process(type)
      x[type].each do |y|
        unless @seen.include? y
          @seen << y
          process(y)
        end
      end
    end

    def x
      @x ||= Transform1.new(input).transform
    end

    def real_input
      File.read("aoc/year2020/day7.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 4, Part1.new(<<~INPUT).solution
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
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

