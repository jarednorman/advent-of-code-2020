module AoC::Year2020::Day3
  RSpec.shared_context "sample input" do
    let(:input) {
      <<~INPUT
        ..##.......
        #...#...#..
        .#....#..#.
        ..#.#...#.#
        .#...##..#.
        ..#.##.....
        .#.#.#....#
        .#........#
        #.##...#...
        #...##....#
        .#..#...#.#
      INPUT
    }
  end

  class Map
    def initialize(map_data)
      @map_data = map_data.split("\n").map(&:chars)
    end

    def get(x, y)
      if @map_data[y][x] == "."
        :empty
      else
        :tree
      end
    end
  end

  RSpec.describe Map do
    include_context "sample input"

    let(:map) { described_class.new(input) }

    describe "#get" do
      it "returns no tree when there's no tree" do
        expect(map.get(0, 0)).to eq :empty
      end
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
      @input ||= File.read("aoc/year2020/day3.txt")
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

