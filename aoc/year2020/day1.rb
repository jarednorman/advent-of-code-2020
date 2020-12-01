module AoC::Year2020::Day1
  class Part1
    def solution
      input.split.map(&:to_i).combination(2).find do |a, b|
        a + b == 2020
      end.inject(&:*)
    end

    private

    def input
      @input ||= File.read("aoc/year2020/day1.txt")
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end
end

RSpec.describe AoC::Year2020::Day1::Part1 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end

RSpec.describe AoC::Year2020::Day1::Part2 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end
