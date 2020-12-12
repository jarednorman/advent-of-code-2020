module AoC::Year2020::Day11
  SeatMap = Struct.new(:map) do
    def self.parse(string_map)
      new(
        string_map.split("\n").map do |line|
          line.chars.map do |c|
            case c
            when "L" then :empty
            when "." then :floor
            when "#" then :taken
            end
          end
        end
      )
    end

    def next
      self.class.new(
        map.each_with_index.map do |row, y|
          row.each_with_index.map do |cell, x|
            next :floor if cell == :floor

            next :taken if cell == :empty && adjacent_seats(x, y) == 0

            next :empty if cell == :taken && adjacent_seats(x, y) >= too_many_count

            cell
          end
        end
      )
    end

    def too_many_count
      4
    end

    def taken_count
      map.flatten.count(:taken)
    end

    def inspect
      map.map do |row|
        row.map do |cell|
          case cell
          when :floor then "."
          when :taken then "#"
          when :empty then "L"
          end
        end.join("")
      end.join("\n")
    end

    private

    def adjacent_seats(x, y)
      [
        taken?(x - 1, y - 1),
        taken?(x - 1, y + 1),
        taken?(x - 1, y),
        taken?(x + 1, y + 1),
        taken?(x + 1, y - 1),
        taken?(x + 1, y),
        taken?(x, y - 1),
        taken?(x, y + 1),
      ].count(&:itself)
    end

    def taken?(x, y)
      return false if x < 0 || y < 0
      return false unless x < width && y < height

      map[y][x] == :taken
    end

    def width
      map.first.length
    end

    def height
      map.length
    end
  end

  class SeatMapTest < Minitest::Test
    def test_parsing
      map = SeatMap.parse(example_layout)

      assert_equal SeatMap.new([
        [:empty, :floor, :empty, :empty, :floor, :empty, :empty, :floor, :empty, :empty],
        [:empty, :empty, :empty, :empty, :empty, :empty, :empty, :floor, :empty, :empty],
        [:empty, :floor, :empty, :floor, :empty, :floor, :floor, :empty, :floor, :floor],
        [:empty, :empty, :empty, :empty, :floor, :empty, :empty, :floor, :empty, :empty],
        [:empty, :floor, :empty, :empty, :floor, :empty, :empty, :floor, :empty, :empty],
        [:empty, :floor, :empty, :empty, :empty, :empty, :empty, :floor, :empty, :empty],
        [:floor, :floor, :empty, :floor, :empty, :floor, :floor, :floor, :floor, :floor],
        [:empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty],
        [:empty, :floor, :empty, :empty, :empty, :empty, :empty, :empty, :floor, :empty],
        [:empty, :floor, :empty, :empty, :empty, :empty, :empty, :floor, :empty, :empty],
      ]), map
    end

    def test_example_next
      map = SeatMap.parse(example_layout)

      assert_equal SeatMap.new([
        [:taken, :floor, :taken, :taken, :floor, :taken, :taken, :floor, :taken, :taken],
        [:taken, :taken, :taken, :taken, :taken, :taken, :taken, :floor, :taken, :taken],
        [:taken, :floor, :taken, :floor, :taken, :floor, :floor, :taken, :floor, :floor],
        [:taken, :taken, :taken, :taken, :floor, :taken, :taken, :floor, :taken, :taken],
        [:taken, :floor, :taken, :taken, :floor, :taken, :taken, :floor, :taken, :taken],
        [:taken, :floor, :taken, :taken, :taken, :taken, :taken, :floor, :taken, :taken],
        [:floor, :floor, :taken, :floor, :taken, :floor, :floor, :floor, :floor, :floor],
        [:taken, :taken, :taken, :taken, :taken, :taken, :taken, :taken, :taken, :taken],
        [:taken, :floor, :taken, :taken, :taken, :taken, :taken, :taken, :floor, :taken],
        [:taken, :floor, :taken, :taken, :taken, :taken, :taken, :floor, :taken, :taken],
      ]), map.next

      assert_equal SeatMap.parse(<<~MAP
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
      MAP
      ), map.next.next
    end

    def example_layout
      <<~MAP
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
      MAP
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      map = map_class.parse(input)

      loop do
        new_map = map.next

        break if new_map == map

        map = new_map
      end

      map.taken_count
    end

    private

    attr_reader :input

    def map_class
      SeatMap
    end

    def real_input
      @input ||= File.read("aoc/year2020/day11.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part1.new(<<~INPUT).solution
      INPUT
    end
  end

  class SeatMap2 < SeatMap
    def too_many_count
      5
    end
 
    def adjacent_seats(x, y)
      [
        [ 0, -1], # N
        [ 1, -1], # NE
        [ 1,  0], # E
        [ 1,  1], # SE
        [ 0,  1], # S
        [-1,  1], # SW
        [-1,  0], # W
        [-1, -1] # NW
      ].map { |direction|
        look(x, y, direction)
      }.tap { |counts|
      }.count { |result|
        result == :taken
      }
    end

    # @return [:taken, :empty]
    def look(x, y, direction)
      loop do
        x += direction[0]
        y += direction[1]

        return :floor unless x >= 0 && y >= 0 && x < width && y < height

        return map[y][x] unless map[y][x] == :floor
      end
    end
  end

  class SeatMap2Test < Minitest::Test
    def test_example_next
      map = SeatMap2.parse(example_layout)

      assert_equal SeatMap2.parse(<<~MAP
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
      MAP
      ), map.next

      assert_equal SeatMap2.parse(<<~MAP
        #.LL.LL.L#
        #LLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLL#
        #.LLLLLL.L
        #.LLLLL.L#
      MAP
      ), map.next.next
    end

    def example_layout
      <<~MAP
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
      MAP
    end
  end

  class Part2 < Part1
    def map_class
      SeatMap2
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part2.new(<<~INPUT).solution
      INPUT
    end
  end
end

