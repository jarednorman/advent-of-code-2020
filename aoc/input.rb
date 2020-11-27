module AoC::Input
  class << self
    def fetch(year:, day:)
      uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = ENV.fetch('AOC_SESSION_COOKIE')
      response = http.request(request)
      response.body
    end
  end
end
