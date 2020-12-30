# frozen_string_literal: true

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

    ICONS = {
      "clear-day" => "\u{2600}",
      "clear-night" => "\u{2600}",
      "rain" => "\u{1f327}",
      "snow" => "\u{1f328}",
      "sleet" => "\u{1f328}",
      "wind" => "\u{1f32c}",
      "fog" => "\u{1f32b}",
      "cloudy" => "\u{2601}",
      "partly-cloudy-day" => "\u{26c5}",
      "partly-cloudy-night" => "\u{26c5}",
    }.freeze

    PRECIPITATIONS = {
      "rain" => "pioggia",
      "snow" => "neve",
      "sleet" => "nevischio",
    }.freeze

    # @param location_name [String] A city name that can be geocoded
    # @param time [Time] A time object that responds to #to_i
    def initialize(location_name, time)
      ForecastIO.api_key = ENV["FORECASTIO_KEY"]
      Geocoder.configure(timeout: 10)

      @location_name = location_name
      @time = time
    end

    # @return [String] A summary of the daily weather
    def daily_forecast
      unless forecast_result
        logger.error("Missing result from ForecastIO") and return
      end

      forecast = forecast_result.daily.data.first
      logger.info(forecast.inspect)

      icon = ICONS[forecast.icon]
      summary = forecast.summary&.downcase&.sub(/\.$/, "")
      temp = if forecast.temperatureMin && forecast.temperatureMin
        "temperatura tra #{forecast.temperatureMin.round} e #{forecast.temperatureMax.round} °C"
      end
      precipitations = if forecast.precipType && forecast.precipProbability >= 0.2
        precipitation = PRECIPITATIONS[forecast.precipType]
        probability = (forecast.precipProbability * 100).round
        "#{probability}% di possibilità di #{precipitation}"
      end
      pressure = "pressione #{forecast.pressure.round}" if forecast.pressure

      text = [summary, precipitations, temp, pressure].compact.join(", ")
      [text, icon].compact.join(" ")
    end

    private

    attr_reader :location_name, :time

    def forecast_result
      @forecast_result ||= begin
        lat, lng = coordinates_for(location_name)
        unless lat
          logger.error("Geocoding failed for #{location_name}") and return
        end

        # API doc: https://darksky.net/dev/docs#time-machine-request
        ForecastIO.forecast(
          lat,
          lng,
          time: time.to_i,
          params: {
            lang: "it",
            units: "ca",
            exclude: "currently,minutely,hourly,alerts,flags"
          }
        )
      end
    end

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
