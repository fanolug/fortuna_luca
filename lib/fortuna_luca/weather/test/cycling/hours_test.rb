require "date"
require_relative "../../../../../test/test_helper"

describe FortunaLuca::Weather::Cycling::Hours do
  let(:instance) { FortunaLuca::Weather::Cycling::Hours.new(location: "Fano", date: date) }
  let(:date) { Date.new(2023, 1, 5) }

  describe '#call' do
    let(:open_weather_response) do
      File.read(File.dirname(__FILE__) + '/../../open_weather/test/fixtures/api_response.json')
    end

    before do
      stub_request(:get, %r{https://api.openweathermap.org/data/3.0/onecall}).to_return(body: open_weather_response)
      FortunaLuca::Weather::Cycling::Hours.any_instance.expects(:coordinates_for).
        with("Fano").
        returns(["43.8441", "13.0170"])
    end

    it 'returns a list of details for the good bike hours' do
      result = instance.call

      result.first.codes.first.must_equal(:cloudy)
      result.first.precipitations.probability.must_equal(0)
      result.first.temperatures.min.must_equal(10)
    end
  end
end
