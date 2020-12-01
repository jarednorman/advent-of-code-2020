module AoC::Year2020::Day1
  class Part1
    def solution(input = real_input)
      input.split.map(&:to_i).combination(2).find do |a, b|
        a + b == 2020
      end.inject(&:*)
    end

    private

    def real_input
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
    subject { instance.solution(input) }

    let(:input) {
      "1721
      979
      366
      299
      675
      1456"
    }

    it { is_expected.to eq 514579 }
  end
end

RSpec.describe AoC::Year2020::Day1::Part2 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end
