require "date"
require_relative "../../../../test/test_helper"
require_relative "../detailed_day_summary"

describe FortunaLuca::Weather::DetailedDaySummary do
  let(:instance) do
    FortunaLuca::Weather::DetailedDaySummary.new(
      location: "Fano",
      date: date,
      show_commuting: true
    )
  end
  let(:date) { Date.new(2023, 1, 5) }

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
        <<~TEXT
        in mattinata nuvoloso, fino al 61% di possibilità di pioggia, 11°C ☁
        Nel pomeriggio abbastanza nuvoloso, 13°C 🌥
        Alla sera un pò nuvoloso, 11°C 🌤
        Pressione 1023, umidità 72%
        Oggi andare al lavoro in bici è rischioso... (ma fa freddino)
        TEXT
      )
    end

    describe 'hourly details are not available' do
      let(:date) { Date.new(2023, 1, 7) }

      it 'falls back to daily summary' do
        FortunaLuca::Weather::DaySummary.any_instance.expects(:coordinates_for).
          with("Fano").
          returns(["43.8441", "13.0170"])
        result = instance.call

        result.must_equal("nuvoloso, temperatura tra 11 e 13 °C, pressione 1022, umidità 83%. ☁")
      end
    end
  end
end
