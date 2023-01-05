require "date"
require_relative "../../../../test/test_helper"
require_relative "../day_summary"

describe FortunaLuca::Weather::DaySummary do
  let(:instance) { FortunaLuca::Weather::DaySummary.new(location: "Fano", date: date) }
  let(:date) { Date.new(2023, 1, 9) }

  describe '#call' do
    let(:open_weather_response) do
      File.read(File.dirname(__FILE__) + '/../open_weather/test/fixtures/api_response.json')
    end

    before do
      stub_request(:get, %r{https://api.openweathermap.org/data/3.0/onecall}).to_return(body: open_weather_response)
      FortunaLuca::Weather::DaySummary.any_instance.expects(:coordinates_for).
        with("Fano").
        returns(["43.8441", "13.0170"])
    end

    it 'returns the text summary' do
      result = instance.call

      result.must_equal(
        "pioggia leggera. 88% di possibilità di precipitazioni (2mm di pioggia), temperatura tra 10 e 14 °C, pressione 1005, umidità 60%. 🌧"
      )
    end
  end
end
