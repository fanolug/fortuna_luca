require "date"
require_relative "../../../../../test/test_helper"

describe FortunaLuca::Weather::TomorrowIO::Client do
  let(:instance) { FortunaLuca::Weather::TomorrowIO::Client.new }

  describe '#call' do
    let(:api_response) do
      File.read(File.dirname(__FILE__) + '/fixtures/api_response.json')
    end

    before do
      stub_request(:get, %r{https://api.tomorrow.io/v4/timelines}).to_return(body: api_response)
    end

    it 'returns the parsed result' do
      result = instance.call('43.8321', '13.0242')

      result.dig("data", "timelines", 0, "timestep").must_equal("1d")
      result.dig("data", "timelines", 0, "intervals", 0, "values", "temperature").must_equal(14.88)
    end
  end
end
