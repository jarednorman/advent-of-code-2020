require 'matrix'

module AoC::Year2020::Day12
  NORTH = Vector[0, 1].freeze
  SOUTH = Vector[0, -1].freeze
  WEST = Vector[-1, 0].freeze
  EAST = Vector[1, 0].freeze

  class Ship
    def initialize(direction: Vector[1, 0], location: Vector[0, 0])
      @direction = direction
      @location = location
    end

    def next(instruction)
      command = instruction[0]
      param = instruction[1..-1].to_i

      case command
      when "F"
        self.class.new(
          direction: direction,
          location: location + direction * param
        )
      when "N"
        self.class.new(
          direction: direction,
          location: location + NORTH * param
        )
      when "S"
        self.class.new(
          direction: direction,
          location: location + SOUTH * param
        )
      when "E"
        self.class.new(
          direction: direction,
          location: location + EAST * param
        )
      when "W"
        self.class.new(
          direction: direction,
          location: location + WEST * param
        )
      when "R"
        self.class.new(
          direction: rotate_right(direction, param/90),
          location: location
        )
      when "L"
        self.class.new(
          direction: rotate_left(direction, param/90),
          location: location
        )
      else
        self
      end
    end

    def rotate_right(direction, times)
      xx = {
        NORTH => EAST,
        EAST => SOUTH,
        SOUTH => WEST,
        WEST => NORTH,
      }

      times.times do
        direction = xx[direction]
      end

      direction
    end

    def rotate_left(direction, times)
      xx = {
        NORTH => WEST,
        WEST => SOUTH,
        SOUTH => EAST,
        EAST => NORTH,
      }

      times.times do
        direction = xx[direction]
      end

      direction
    end

    def manhattan_distance
      location.to_a.map(&:abs).sum
    end

    attr_reader :location, :direction
  end

  class TestShip < Minitest::Test
    def test_movement
      ship = Ship.new
      assert_equal 0, ship.manhattan_distance

      ship = ship.next "F10"
      assert_equal 10, ship.manhattan_distance
      assert_equal Vector[10, 0], ship.location

      ship = ship.next "N3"
      assert_equal 13, ship.manhattan_distance
      assert_equal Vector[10, 3], ship.location

      ship = ship.next "F7"
      assert_equal 20, ship.manhattan_distance
      assert_equal Vector[17, 3], ship.location

      ship = ship.next "R90"
      assert_equal 20, ship.manhattan_distance
      assert_equal Vector[17, 3], ship.location
      assert_equal Vector[0, -1], ship.direction

      ship = ship.next "F11"
      assert_equal 25, ship.manhattan_distance
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input.split("\n")
    end

    def solution
      ship = Ship.new

      input.each do |x|
        ship = ship.next x
      end

      ship.manhattan_distance
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day12.txt")
    end
  end

  class Part1Test < Minitest::Test
  end

  class Part2 < Part1
    def solution
      0
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part2.new(<<~INPUT).solution
      INPUT
    end
  end
end

