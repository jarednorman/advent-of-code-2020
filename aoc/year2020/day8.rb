module AoC::Year2020::Day8
  class Parser
    def initialize(input)
      @input = input
    end

    def parse
      @input.split("\n").map do |line|
        instruction, number = *line.split(" ")
        [instruction.to_sym, number.to_i]
      end
    end
  end

  class ParserTest < Minitest::Test
    def test_it_parses
      expected = [
        [:nop, 0],
        [:acc, 1],
        [:jmp, 4],
        [:acc, 3],
        [:jmp, -3],
        [:acc, -99],
        [:acc, 1],
        [:jmp, -4],
        [:acc, 6]
      ]

      assert_equal expected, Parser.new(<<~INPUT).parse
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
      INPUT
    end
  end

  Machine = Struct.new(:program, :pointer, :accumulator, :prev_pointers) do
    def next
      new_machine unless prev_pointers.include?(new_machine.pointer)
    end

    def instruction
      @instruction ||= program[pointer]
    end

    def new_machine
      case instruction.first
      when :nop then Machine.new(program, pointer + 1, accumulator, prev_pointers + [pointer])
      when :acc then Machine.new(program, pointer + 1, accumulator + instruction.last, prev_pointers + [pointer])
      when :jmp then Machine.new(program, pointer + instruction.last, accumulator, prev_pointers + [pointer])
      end
    end
  end

  class MachineTest < Minitest::Test
    def test_loop
      program = [[:nop, 0], [:jmp, -1], [:nop, 0]]
      machine = Machine.new(program, 0, 0, [])

      assert_nil machine.next.next
    end

    def test_nop
      program = [[:nop, 0], [:nop, 0], [:nop, 0]]
      machine = Machine.new(program, 0, 0, [])

      assert_equal Machine.new(program, 1, 0, [0]), machine.next
    end

    def test_acc
      program = [[:nop, 0], [:acc, 3], [:nop, 0]]
      machine = Machine.new(program, 1, 0, [])

      assert_equal Machine.new(program, 2, 3, [1]), machine.next
    end

    def test_jmp
      program = [[:nop, 0], [:acc, 3], [:jmp, -2]]
      machine = Machine.new(program, 2, 3, [])

      assert_equal Machine.new(program, 0, 3, [2]), machine.next
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.new(input).parse
    end

    def solution
      machine = Machine.new(input, 0, 0, [])

      loop do
        next_machine = machine.next
        return machine.accumulator if next_machine.nil?
        machine = next_machine
      end
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day8.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 5, Part1.new(<<~INPUT).solution
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
      INPUT
    end
  end

  class Part2 < Part1
    def solution
      input.each_with_index.select do |instruction, index|
        [:nop, :jmp].include?(instruction.first)
      end.map(&:last).each do |index|
        program = input.dup
        program[index] = [{jmp: :nop, nop: :jmp}[program[index].first], program[index].last]

        machine = compute(Machine.new(program, 0, 0, []))
        return machine.accumulator if machine
      end
    end

    def compute(machine)
      if machine.nil?
        nil
      elsif machine.pointer == machine.program.length
        machine
      else
        compute(machine.next)
      end
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 8, Part2.new(<<~INPUT).solution
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
      INPUT
    end
  end
end

