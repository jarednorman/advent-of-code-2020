module AoC::Year2019::Day4
  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      0
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2019/day4.txt")
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end
end

RSpec.describe "Day 4" do
  let(:input) {
    <<~INPUT
    INPUT
  }

  describe AoC::Year2019::Day4::Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }
    end
  end

  describe AoC::Year2019::Day4::Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }
    end
  end
end
