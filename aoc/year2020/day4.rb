module AoC::Year2020::Day4
  RSpec.shared_context "sample input" do
    let(:input) {
      <<~INPUT
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
      INPUT
    }
  end

  module Parser
  end

  RSpec.describe Parser do
    subject { described_class.parse(records) }

    let(:records) {
      <<~RECORDS
        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm
      RECORDS
    }
                    
    it "parses inputs", :pending do
      expect(subject).to eq([
        {
          iyr: "2013",
          ecl: "amb",
          cid: "350",
          eyr: "2023",
          pid: "028048884",
          hcl: "#cfa07d",
          byr: "1929"
        },
        {
          hcl: "#ae17e1",
          iyr: "2013",
          eyr: "2024",
          ecl: "brn",
          pid: "760753108",
          byr: "1931",
          hgt: "179cm"
        }
      ])
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
      @input ||= File.read("aoc/year2020/day4.txt")
    end
  end

  RSpec.describe Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"

      it "solves the sample input", :pending do
        expect(subject).to eq 2
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
    end
  end
end

