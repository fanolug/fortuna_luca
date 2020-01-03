require "forecast_io"
require "geocoder/configuration"
require "geocoder/logger"
require "geocoder/kernel_logger"
require "geocoder/query"
require "geocoder/lookup"
require "geocoder/exceptions"
require_relative "../logging"

module FortunaLuca
  class Forecaster
    include Logging

    FORECAST_ICONS = {
      "clear-day" => "\u{2600}",
      "clear-night" => "\u{2600}",
      "rain" => "\u{1f327}",
      "snow" => "\u{1f328}",
      "sleet" => "\u{1f328}",
      "wind" => "\u{1f32c}",
      "fog" => "\u{1f32b}",
      "cloudy" => "\u{2601}",
      "partly-cloudy-day" => "\u{26c5}",
      "partly-cloudy-night" => "\u{26c5}"
    }

    def initialize
      ForecastIO.api_key = ENV["FORECASTIO_KEY"]
    end

    # @param location_name [String] A city name that can be geocoded
    # @param time [Time] A time object that responds to #to_i
    # @return [String] A summary of the daily weather
    def daily_forecast_for(location_name, time)
      lat, lng = coordinates_for(location_name)
      unless lat
        logger.error("Geocoding failed for #{location_name}") and return
      end

      # API doc: https://darksky.net/dev/docs#time-machine-request
      result = ForecastIO.forecast(
        lat,
        lng,
        time: time.to_i,
        params: {
          lang: "it",
          units: "ca",
          exclude: "currently,minutely,hourly,alerts,flags"
        }
      )
      unless result
        logger.error("Missing result from ForecastIO") and return
      end

      forecast = result.daily.data.first
      logger.info(forecast.inspect)
      icon = FORECAST_ICONS[forecast.icon]
      summary = forecast.summary.downcase.sub(/\.$/, "")
      temp = "temperatura tra #{forecast.temperatureMin.round} e #{forecast.temperatureMax.round} °C"

      "#{summary}, #{temp} #{icon}"
    end

    private

    # @param location_name [String] A city name that can be geocoded
    # @return [Array] Latitude and longitude of ther location
    def coordinates_for(location_name)
      Geocoder::Query.new(location_name).
        execute.
        first&.
        coordinates
    end
  end
end
