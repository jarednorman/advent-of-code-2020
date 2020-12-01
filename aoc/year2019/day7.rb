module AoC::Year2019::Day7
  class Part1
    def solution
      0
    end

    private

    def input
      @input ||= File.read("aoc/year2019/day7.txt")
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end
end

RSpec.describe AoC::Year2019::Day7::Part1 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end

RSpec.describe AoC::Year2019::Day7::Part2 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end
