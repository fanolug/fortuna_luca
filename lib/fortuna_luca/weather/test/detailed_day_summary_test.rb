require "date"
require_relative "../../../../test/test_helper"
require_relative "../detailed_day_summary"

describe FortunaLuca::Weather::DetailedDaySummary do
  let(:instance) { FortunaLuca::Weather::DetailedDaySummary.new(location: "Fano", date: date) }
  let(:date) { Date.new(2023, 1, 9) }

  describe '#call' do
    let(:open_weather_response) do
      File.read(File.dirname(__FILE__) + '/../open_weather/test/fixtures/api_response.json')
    end

    before do
      stub_request(:get, %r{https://api.openweathermap.org/data/3.0/onecall}).to_return(body: open_weather_response)
      FortunaLuca::Weather::DetailedDaySummary.any_instance.expects(:coordinates_for).
        with("Fano").
        returns(["43.8441", "13.0170"])
    end

    it 'returns the text summary' do
      result = instance.call

      result.must_equal(
        <<~TEXT
        In mattinata pioggia leggera, fino al 61% di possibilità di pioggia, 11°C 🌦☁🌤🌞
        Nel pomeriggio nuvoloso, 12°C ☁🌥🌤
        Alla sera sereno, 11°C 🌞🌞🌤🌤🌥
        Pressione 1005, umidità 60%
        Oggi fa andare al lavoro in bici.
        TEXT
      )
    end
  end
end
