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
    class << self
      def parse(input)
        input.split("\n\n").map do |record|
          record.split(/\s/).each_with_object({}) do |pair, memo|
            key, value = pair.split(":")
            memo[key.to_sym] = value
          end
        end
      end
    end
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
                    
    it "parses inputs" do
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

  class Passport
    def initialize(record)
      @record = record
    end

    def valid?
      (@record.keys - [:cid]).length == 7
    end
  end

  RSpec.describe Passport do
    describe "#valid?" do
      subject { described_class.new(record).valid? }

      context "when it is valid" do
        let(:record) {
          {
            hcl: "#ae17e1",
            iyr: "2013",
            eyr: "2024",
            ecl: "brn",
            pid: "760753108",
            byr: "1931",
            hgt: "179cm"
          }
        }

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "when it is not valid" do
        let(:record) {
          {
            iyr: "2013",
            ecl: "amb",
            cid: "350",
            eyr: "2023",
            pid: "028048884",
            hcl: "#cfa07d",
            byr: "1929"
          }
        }

        it "returns false" do
          expect(subject).to eq false
        end
      end
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input
    end

    def solution
      Parser.parse(input).count do |record|
        passport_class.new(record).valid?
      end
    end

    private

    attr_reader :input

    def passport_class
      Passport
    end

    def real_input
      @input ||= File.read("aoc/year2020/day4.txt")
    end
  end

  RSpec.describe Part1 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"

      it "solves the sample input" do
        expect(subject).to eq 2
      end
    end
  end

  class Part2 < Part1
  end

  RSpec.describe Part2 do
    let(:instance) { described_class.new(input) }

    describe "#solution" do
      subject { instance.solution }

      include_context "sample input"
    end
  end
end

