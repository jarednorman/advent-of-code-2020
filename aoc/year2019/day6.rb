class AoC::Year2019::Day6
  def solution
    0
  end

  def input
    @input ||= File.read("aoc/year2019/day6.txt")
  end
end

RSpec.describe AoC::Year2019::Day6 do
  let(:instance) { described_class.new }

  describe "#solution" do
    subject { instance.solution }

    it { is_expected.to eq 0 }
  end
end
