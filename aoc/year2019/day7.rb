module AoC::Year2019::Day7
  class PartOne
    def solution
      0
    end

    private

    def input
      @input ||= File.read("aoc/year2019/day7.txt")
    end
  end

  class PartTwo < PartOne
    def solution
      0
    end
  end
end

RSpec.describe AoC::Year2019::Day7::PartOne do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end

RSpec.describe AoC::Year2019::Day7::PartTwo do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }
  end
end
