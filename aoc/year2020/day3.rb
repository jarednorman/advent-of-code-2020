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
      x, y = 0, 0
      trees = 0

      while y < map.height
        trees += 1 if map.get(x, y) == :tree

        x += 3
        y += 1
      end

      trees
    end

    private

    attr_reader :input

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
      0
    end
  end

  RSpec.describe Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"

      it "does the right thing", :pending do
        expect(subject).to eq 336
      end
    end
  end
end

