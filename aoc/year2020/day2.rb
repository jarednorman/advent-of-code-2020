module AoC::Year2020::Day2
  class Policy
    def initialize(range, letter)
      start, finish = range.split("-").map(&:to_i)
      @range = start..finish
    end

    attr_reader :range
  end

  class Password
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
  describe AoC::Year2020::Day2::Policy do
    subject { described_class.new("1-2", "x") }

    it "has a range" do
      expect(subject.range).to eq(1..2)
    end
  end

  describe AoC::Year2020::Day2::Password do
    describe "#valid?" do
      subject { described_class.new(password).valid? }

      context "when the password is valid" do
        let(:password) { "1-3 a: abcde" }

        it "is true", :pending do
          expect(subject).to eq true
        end
      end

      context "when the password is invalid" do
        let(:password) { "1-3 b: cdefg" }

        it "is false", :pending do
          expect(subject).to eq false
        end
      end
    end
  end

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
