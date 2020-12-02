module AoC::Year2020::Day2
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
      @input ||= File.read("aoc/year2020/day2.txt")
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end
end

RSpec.describe "Year 2020 Day 2" do
  let(:input) {
    <<~INPUT
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    INPUT
  }

  describe AoC::Year2020::Day2::Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      it "does the test input right", :pending do
        expect(subject).to eq 2
      end
    end
  end

  describe AoC::Year2020::Day2::Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }
    end
  end
end
