module AoC::Year2020::Day17
  class State
    def self.parse(input, dimensions)
      h = new_h(dimensions)

      input.split("\n").reverse.each_with_index do |line, row|
        line.chars.each_with_index do |x, col|
          nested_assign(h, [col, row, *(dimensions - 2).times.map { 0 }]) if x == "#"
        end
      end

      new(h, dimensions)
    end

    def self.new_h(dimensions)
      if dimensions == 3
        Hash.new { |hash, key|
          hash[key] = Hash.new { |hash, key|
            hash[key] = {}
          }
        }
      else
        Hash.new { |hash, key|
          hash[key] = Hash.new { |hash, key|
            hash[key] = Hash.new { |hash, key|
              hash[key] = {}
            }
          }
        }
      end
    end

    def self.nested_assign(h, coords)
      target = coords[0..-2].inject(h) { |acc, coord| acc[coord] }
      target[coords.last] = true
    end

    def initialize(state, dimensions)
      @state = state
      @dimensions = dimensions
    end

    def [](*coords)
      coords.inject(@state) { |acc, i| acc[i] }
    end

    def cycle
      h = State.new_h(@dimensions)

      possible_coordinates.each do |coords|
        if self[*coords]
          State.nested_assign(h, coords) if [2, 3].include?(neighbour_count(*coords))
        else
          State.nested_assign(h, coords) if neighbour_count(*coords) == 3
        end
      end

      State.new(h, @dimensions)
    end

    def count
      if @dimensions == 3
        @state.values.flat_map(&:values).flat_map(&:values).count
      else
        @state.values.flat_map(&:values).flat_map(&:values).flat_map(&:values).count
      end
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
      @live_coordinates ||=
        if @dimensions == 3
          @state.flat_map { |x,rest|
            rest.flat_map { |y,rest|
              rest.map { |z, _|
                [x, y, z]
              }
            }
          }
        else
          @state.flat_map { |x,rest|
            rest.flat_map { |y,rest|
              rest.flat_map { |z, rest|
                rest.map { |w, _|
                  [x, y, z, w]
                }
              }
            }
          }
        end
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
      state = State.parse(<<~INPUT, 3)
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
      state = State.parse(<<~INPUT, 3).cycle
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

    def test_cycle_4d
      state = State.parse(<<~INPUT, 4).cycle
        .#.
        ..#
        ###
      INPUT

      assert state[0,  1, 0, 0]
      refute state[1,  1, 0, 0]
      assert state[2,  1, 0, 0]
      refute state[0,  0, 0, 0]
      assert state[1,  0, 0, 0]
      assert state[2,  0, 0, 0]
      refute state[0, -1, 0, 0]
      assert state[1, -1, 0, 0]
      refute state[2, -1, 0, 0]

      [-1, 0, 1].each do |z|
        [-1, 0, 1].each do |w|
          next if [z, w] == [0, 0]
          assert state[0,  1, z, w]
          refute state[1,  1, z, w]
          refute state[2,  1, z, w]
          refute state[0,  0, z, w]
          refute state[1,  0, z, w]
          assert state[2,  0, z, w]
          refute state[0, -1, z, w]
          assert state[1, -1, z, w]
          refute state[2, -1, z, w]
        end
      end

      assert_equal 29, state.count
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      s = State.parse(input, dimension_count)

      6.times do
        s = s.cycle
      end

      s.count
    end

    private

    attr_reader :input

    def dimension_count
      3
    end

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
    def dimension_count
      4
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 848, Part2.new(<<~INPUT).solution
        .#.
        ..#
        ###
      INPUT
    end
  end
end

