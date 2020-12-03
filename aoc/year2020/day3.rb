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
      if @map_data[y][x % @map_data.first.length] == "."
        :empty
      else
        :tree
      end
    end

    def height
      @map_data.length
    end
  end

  RSpec.describe Map do
    include_context "sample input"

    let(:map) { described_class.new(input) }

    describe "#height" do
      it "returns the height of the map" do
        expect(map.height).to eq 11
      end
    end

    describe "#get" do
      it "returns no tree when there's no tree" do
        expect(map.get(0, 0)).to eq :empty
      end

      it "returns a tree when there's a tree" do
        expect(map.get(3, 0)).to eq :tree
      end

      it "loops" do
        expect(map.get(13, 0)).to eq :tree
      end
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      count_trees(3, 1)
    end

    private

    attr_reader :input

    def count_trees(slope_x, slope_y)
      x, y = 0, 0
      trees = 0

      while y < map.height
        trees += 1 if map.get(x, y) == :tree

        x += slope_x
        y += slope_y
      end

      trees
    end

    def real_input
      @input ||= File.read("aoc/year2020/day3.txt")
    end

    def map
      @map ||= Map.new(input)
    end
  end

  RSpec.describe Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"

      it "matches what they told us" do
        expect(subject).to eq 7
      end
    end
  end

  class Part2 < Part1
    def solution
      [[1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2]].map do |sx, sy|
        count_trees sx, sy
      end.inject(&:*)
    end
  end

  RSpec.describe Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"

      it "does the right thing" do
        expect(subject).to eq 336
      end
    end
  end
end

