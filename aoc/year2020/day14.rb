module AoC::Year2020::Day14
  Word = Struct.new(:bits) do
    class << self
      def from_int(int)
        new(int.to_s(2).rjust(36, '0').chars)
      end
    end

    def to_i
      bits.join.to_i(2)
    end

    def masked(mask)
      Word.new(mask.chars.zip(bits).map {|x,y| if x == "X" then y else x end })
    end

    def float(mask)
      mask = mask.chars

      recur_float(0, mask).map do |b|
        Word.new(b)
      end
    end

    def recur_float(n, mask)
      if n == bits.length - 1
        nth_slot n, mask
      else
        opts = nth_slot n, mask
        recur_float(n + 1, mask).flat_map do |opt|
          opts.map do |o|
            [o, *opt]
          end
        end
      end
    end

    def nth_slot(n, mask)
      if mask[n] == "X"
        ["0", "1"]
      elsif mask[n] == "1"
        ["1"]
      else
        [bits[n]]
      end
    end
  end

  class WordTest < Minitest::Test
    def test_float
      word = Word.from_int(42)
      assert_equal Set[
        Word.from_int(26),
        Word.from_int(27),
        Word.from_int(58),
        Word.from_int(59)
      ], Set.new(word.float("000000000000000000000000000000X1001X"))
    end

    def test_from_int
      assert_equal Word.new(["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "0", "1", "1"]), Word.from_int(11)
    end

    def test_to_i
      assert_equal 11, Word.new(["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "0", "1", "1"]).to_i
    end

    def test_masked
      word = Word.new(["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "0", "1", "1"])
      word = word.masked "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"

      assert_equal 73, word.to_i
    end
  end

  module Parser
    class << self
      def parse(input)
        input.split("\n").map do |line|
          if line[0..3] == "mask"
            match = /mask = ([01X]{36})/.match(line)
            MaskInst.new(match[1])
          else match = /mem\[(\d+)\] = (\d+)/.match(line)
            WriteInst.new(match[1].to_i, Word.from_int(match[2].to_i))
          end
        end
      end
    end
  end

  class ParserTest < Minitest::Test
    def test_sample_input
      input = <<~INPUT
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
      INPUT

      assert_equal [
        MaskInst.new("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"),
        WriteInst.new(8, Word.from_int(11)),
        WriteInst.new(7, Word.from_int(101)),
        WriteInst.new(8, Word.from_int(0))
      ], Parser.parse(input)
    end
  end

  MaskInst = Struct.new(:mask)
  WriteInst = Struct.new(:address, :value)

  class Machine
    def initialize
      @memory = {}
    end

    attr_reader :program, :mask, :memory

    def step(inst)
      case inst
      when MaskInst then @mask = inst.mask
      when WriteInst
        memory[inst.address] = inst.value.masked(mask)
      end
    end

    def sum
      memory.values.map(&:to_i).sum
    end
  end

  class MachineTest < Minitest::Test
    def test_example
      m = Machine.new

      m.step MaskInst.new("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      assert_equal "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", m.mask

      m.step WriteInst.new(8, Word.from_int(11))
      assert_equal 73, m.memory[8].to_i

      m.step WriteInst.new(7, Word.from_int(101))
      assert_equal 101, m.memory[7].to_i

      m.step WriteInst.new(8, Word.from_int(0))
      assert_equal 64, m.memory[8].to_i

      assert_equal 165, m.sum
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      m = machine_class.new
      program = Parser.parse(input)

      program.each do |instruction|
        m.step instruction
      end

      m.sum
    end

    private

    def machine_class
      Machine
    end

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day14.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part1.new(<<~INPUT).solution
      INPUT
    end
  end

  class Machine2 < Machine
    def step(inst)
      case inst
      when MaskInst then @mask = inst.mask
      when WriteInst
        Word.from_int(inst.address).float(mask).each do |address|
          memory[address.to_i] = inst.value
        end
      end
    end
  end

  class Machine2Test < Minitest::Test
    def test_example
      m = Machine2.new

      m.step MaskInst.new("000000000000000000000000000000X1001X")
      assert_equal "000000000000000000000000000000X1001X", m.mask

      m.step WriteInst.new(42, Word.from_int(100))

      m.step MaskInst.new("00000000000000000000000000000000X0XX")
      assert_equal "00000000000000000000000000000000X0XX", m.mask

      m.step WriteInst.new(26, Word.from_int(1))

      assert_equal 208, m.sum
    end
  end

  class Part2 < Part1
    def machine_class
      Machine2
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 208, Part2.new(<<~INPUT).solution
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
      INPUT
    end
  end
end

