module AoC::Year2020::Day5
  RSpec.shared_context "sample input" do
    let(:input) {
      <<~INPUT
      INPUT
    }
  end

  class BoardingPass
  end

  RSpec.describe BoardingPass do
    it "works for the examples", :pending do
      pass = described_class.new("BFFFBBFRRR")
      expect(pass.row).to eq 70
      expect(pass.column).to eq 7
      expect(pass.id).to eq 567
      pass = described_class.new("FFFBBBFRRR")
      expect(pass.row).to eq 14
      expect(pass.column).to eq 7
      expect(pass.id).to eq 119
      pass = described_class.new("BBFFBBFRLL")
      expect(pass.row).to eq 102
      expect(pass.column).to eq 4
      expect(pass.id).to eq 820
    end
  end

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
      @input ||= File.read("aoc/year2020/day5.txt")
    end
  end

  RSpec.describe Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end

  RSpec.describe Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"
    end
  end
end

