module AoC::Year2020::Day5
  RSpec.shared_context "sample input" do
    let(:input) {
      <<~INPUT
      INPUT
    }
  end

  class BoardingPass
    def initialize(partition)
      @row_steps = partition.chars[0..6]
      @col_steps = partition.chars[7..9]
    end

    def row
      arr = (0..127).to_a
    end
  end

  RSpec.describe BoardingPass do
    let(:pass1) { described_class.new("BFFFBBFRRR") }
    let(:pass2) { described_class.new("FFFBBBFRRR") }
    let(:pass3) { described_class.new("BBFFBBFRLL") }

    it "computes rows", :pending do
      expect(pass1.row).to eq 70
      expect(pass2.row).to eq 14
      expect(pass3.row).to eq 102
    end

    it "computes columns", :pending do
      expect(pass1.column).to eq 7
      expect(pass2.column).to eq 7
      expect(pass3.column).to eq 4
    end

    it "computes ids", :pending do
      expect(pass1.id).to eq 567
      expect(pass2.id).to eq 119
      expect(pass3.id).to eq 820
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

