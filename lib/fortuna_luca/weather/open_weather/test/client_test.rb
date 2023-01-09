require "date"
require_relative "../../../../../test/test_helper"
require_relative "../client"

describe FortunaLuca::Weather::OpenWeather::Client do
  let(:instance) { FortunaLuca::Weather::OpenWeather::Client.new }

  describe '#call' do
    let(:api_response) do
      File.read(File.dirname(__FILE__) + '/fixtures/api_response.json')
    end

    before do
      stub_request(:get, %r{https://api.openweathermap.org/data/3.0/onecall}).to_return(body: api_response)
    end

    it 'returns the parsed result' do
      result = instance.call('43.8321', '13.0242')

      result["lat"].must_equal(43.8321)
      result["timezone"].must_equal("Europe/Rome")
      result["current"]["temp"].must_equal(9.6)
      result["hourly"].first["pressure"].must_equal(1004)
      result["daily"].last["temp"]["day"].must_equal(10.13)
    end
  end
end
