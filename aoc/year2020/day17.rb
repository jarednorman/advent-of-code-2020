module AoC::Year2020::Day17
  class State
    def self.parse(input)
      h = new_h

      input.split("\n").reverse.each_with_index do |line, row|
        line.chars.each_with_index do |x, col|
          h[col][row][0] = true if x == "#"
        end
      end

      new(h)
    end

    def self.new_h
      Hash.new { |hash, key|
        hash[key] = Hash.new { |hash, key|
          hash[key] = {}
        }
      }
    end

    def initialize(state)
      @state = state
    end

    def [](*coords)
      coords.inject(@state) { |acc, i| acc[i] }
    end

    def cycle
      h = State.new_h

      possible_coordinates.each do |x, y, z|
        if self[x, y, z]
          h[x][y][z] = true if [2, 3].include?(neighbour_count(x, y, z))
        else
          h[x][y][z] = true if neighbour_count(x, y, z) == 3
        end
      end

      State.new(h)
    end

    def count
      @state.flat_map { |k,v|
        v.map { |k,v|
          v.count { |k,v| v }
        }
      }.sum
    end

    private

    def possible_coordinates
      live_coordinates.flat_map do |coords|
        [coords, *neighbours(*coords)]
      end.uniq
    end

    def neighbour_count(*coords)
      neighbours(*coords).count { |coords|
        self[*coords]
      }
    end

    def live_coordinates
      @live_coordinates ||= @state.flat_map {|x,rest| rest.flat_map{|y,rest| rest.map {|z, _| [x, y, z] }}}
    end

    def neighbours(*coords)
      foo(coords) - [coords]
    end

    def foo(coords)
      if coords.length == 1
        [-1, 0, 1].map { |offset|
          [coords.first + offset]
        }
      else
        [-1, 0, 1].flat_map { |offset|
          foo(coords[1..-1]).map { |rest|
            [coords.first + offset, *rest]
          }
        }
      end
    end
  end

  class StateTest < Minitest::Test
    def test_parsing
      state = State.parse(<<~INPUT)
        .#.
        ..#
        ###
      INPUT

      assert state[0, 0, 0]
      assert state[1, 0, 0]
      assert state[2, 0, 0]
      refute state[0, 1, 0]
      refute state[1, 1, 0]
      assert state[2, 1, 0]
      refute state[0, 2, 0]
      assert state[1, 2, 0]
      refute state[2, 2, 0]
    end

    def test_cycle
      state = State.parse(<<~INPUT).cycle
        .#.
        ..#
        ###
      INPUT

      assert state[0,  1, 0]
      refute state[1,  1, 0]
      assert state[2,  1, 0]
      refute state[0,  0, 0]
      assert state[1,  0, 0]
      assert state[2,  0, 0]
      refute state[0, -1, 0]
      assert state[1, -1, 0]
      refute state[2, -1, 0]

      assert_equal 11, state.count
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      s = State.parse(input)

      6.times do
        s = s.cycle
      end

      s.count
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day17.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 112, Part1.new(<<~INPUT).solution
        .#.
        ..#
        ###
      INPUT
    end
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

