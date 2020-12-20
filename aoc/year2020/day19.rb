module AoC::Year2020::Day19
  class Parser
    def initialize(input)
      @input = input
    end

    def rules
      input.split("\n\n").first.split("\n").each_with_object({}) do |rule, rules|
        rule_number, rule_defn = *rule.split(": ")

        if m = /"(\w)"/.match(rule_defn)
          rules[rule_number.to_i] = m[1]
        else
          rules[rule_number.to_i] = rule_defn.split(" | ").map do |x|
            x.split(" ").map(&:to_i)
          end
        end
      end
    end

    def messages
      input.split("\n\n").last.split("\n")
    end

    private

    attr_reader :input
  end

  class ParserTest < Minitest::Test
    def test_parsing
      input = <<~INPUT
        0: 4 1 5
        1: 2 3 | 3 2
        2: 4 4 | 5 5
        3: 4 5 | 5 4
        4: "a"
        5: "b"

        ababbb
        bababa
        abbbab
        aaabbb
        aaaabbb
      INPUT

      parser = Parser.new(input)

      assert_equal(
        %w[ababbb bababa abbbab aaabbb aaaabbb],
        parser.messages
      )

      assert_equal(
        {
          0 => [[4, 1, 5]],
          1 => [[2, 3], [3, 2]],
          2 => [[4, 4], [5, 5]],
          3 => [[4, 5], [5, 4]],
          4 => "a",
          5 => "b"
        },
        parser.rules
      )
    end
  end

  class RuleSet
    def initialize(rules)
      @rules = rules
    end

    def match?(m)
      regex.match? m
    end

    private

    attr_reader :rules

    def regex
      @regex ||= Regexp.new("\\A#{to_regex(0)}\\z")
    end

    def to_regex(n)
      case rules[n]
      when String then rules[n]
      when Array
        "(#{rules[n].map { |r|
          r.map { |rn| to_regex(rn) }.join
        }.join("|")})"
      end
    end
  end

  class RuleSetTest < Minitest::Test
    def test_example
      ruleset = RuleSet.new(0 => "a")
      assert ruleset.match?("a")
      refute ruleset.match?("b")

      ruleset = RuleSet.new(
        0 => [[1, 2]],
        1 => "a",
        2 => "b"
      )
      assert ruleset.match?("ab")
      refute ruleset.match?("ba")
      refute ruleset.match?("aa")

      ruleset = RuleSet.new(
        0 => [[1, 2], [2, 1]],
        1 => "a",
        2 => "b"
      )
      assert ruleset.match?("ab")
      assert ruleset.match?("ba")
      refute ruleset.match?("aa")
      refute ruleset.match?("bb")

      ruleset = RuleSet.new(
        0 => [[4, 1, 5]],
        1 => [[2, 3], [3, 2]],
        2 => [[4, 4], [5, 5]],
        3 => [[4, 5], [5, 4]],
        4 => "a",
        5 => "b"
      )

      assert ruleset.match?("ababbb")
      refute ruleset.match?("bababa")
      assert ruleset.match?("abbbab")
      refute ruleset.match?("aaabbb")
      refute ruleset.match?("aaaabbb")
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.new(input)
    end

    def solution
      ruleset = ruleset_class.new(rules)

      messages.count { |m| ruleset.match? m }
    end

    private

    attr_reader :input

    def ruleset_class
      RuleSet
    end

    def rules
      input.rules
    end

    def messages
      input.messages
    end

    def real_input
      @input ||= File.read("aoc/year2020/day19.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 2, Part1.new(<<~INPUT).solution
        0: 4 1 5
        1: 2 3 | 3 2
        2: 4 4 | 5 5
        3: 4 5 | 5 4
        4: "a"
        5: "b"

        ababbb
        bababa
        abbbab
        aaabbb
        aaaabbb
      INPUT
    end
  end

  class RuleSet2 < RuleSet
    def initialize(rules)
      super
      rules[8] = "(#{to_regex(42)}+)"
      rules[11] = "(?<re>(#{to_regex(42)})\\g<re>?(#{to_regex(31)}))"
    end
  end

  class Part2 < Part1
    def ruleset_class
      RuleSet2
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 12, Part2.new(<<~INPUT).solution
        42: 9 14 | 10 1
        9: 14 27 | 1 26
        10: 23 14 | 28 1
        1: "a"
        11: 42 31
        5: 1 14 | 15 1
        19: 14 1 | 14 14
        12: 24 14 | 19 1
        16: 15 1 | 14 14
        31: 14 17 | 1 13
        6: 14 14 | 1 14
        2: 1 24 | 14 4
        0: 8 11
        13: 14 3 | 1 12
        15: 1 | 14
        17: 14 2 | 1 7
        23: 25 1 | 22 14
        28: 16 1
        4: 1 1
        20: 14 14 | 1 15
        3: 5 14 | 16 1
        27: 1 6 | 14 18
        14: "b"
        21: 14 1 | 1 14
        25: 1 1 | 1 14
        22: 14 14
        8: 42
        26: 14 22 | 1 20
        18: 15 15
        7: 14 5 | 1 21
        24: 14 1

        abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
        bbabbbbaabaabba
        babbbbaabbbbbabbbbbbaabaaabaaa
        aaabbbbbbaaaabaababaabababbabaaabbababababaaa
        bbbbbbbaaaabbbbaaabbabaaa
        bbbababbbbaaaaaaaabbababaaababaabab
        ababaaaaaabaaab
        ababaaaaabbbaba
        baabbaaaabbaaaababbaababb
        abbbbabbbbaaaababbbbbbaaaababb
        aaaaabbaabaaaaababaa
        aaaabbaaaabbaaa
        aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
        babaaabbbaaabaababbaabababaaab
        aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
      INPUT
    end
  end
end

