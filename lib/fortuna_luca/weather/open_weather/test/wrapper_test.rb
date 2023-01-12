require "date"
require_relative "../../../../../test/test_helper"
require_relative "../wrapper"

describe FortunaLuca::Weather::OpenWeather::Wrapper do
  let(:instance) do
    FortunaLuca::Weather::OpenWeather::Wrapper.new(lat: '43.8321', lon: '13.0242', date: date)
  end
  let(:date) { Date.new(2023, 1, 9) }
  let(:api_response) do
    File.read(File.dirname(__FILE__) + '/fixtures/api_response.json')
  end

  describe '#call' do
    before do
      stub_request(:get, %r{https://api.openweathermap.org/data/3.0/onecall}).to_return(body: api_response)
    end

    it 'returns the weather result object' do
      result = instance.call

      result.success.must_equal(true)
      result.daily.must_equal(
        FortunaLuca::Weather::Detail.new(
          time: 1673262000,
          codes: [:light_rain],
          text_summary: "pioggia leggera",
          precipitations: { probability: 88, rain: 2, snow: 0 },
          temperatures: { min: 10, max: 14 },
          wind: { speed: 10, deg: 260, gust: 16 },
          pressure: 1005,
          humidity: 60
        )
      )
      result.hourly.first.must_equal(
        FortunaLuca::Weather::Detail.new(
          time: 1672826400,
          codes: [:light_rain],
          text_summary: "pioggia leggera",
          precipitations: { probability: 61, rain: 23, snow: 0 },
          temperatures: { min: 9, max: 9 },
          wind: { speed: 7, deg: 315, gust: 11 },
          pressure: 1004,
          humidity: 82
        )
      )
    end
  end
end