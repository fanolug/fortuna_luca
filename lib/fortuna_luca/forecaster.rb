# frozen_string_literal: true

require "i18n"
require "forecast_io"
require "geocoder/configuration"
require "geocoder/logger"
require "geocoder/kernel_logger"
require "geocoder/query"
require "geocoder/lookup"
require "geocoder/exceptions"
require_relative "logging"

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
      "rain" => I18n.t('forecaster.rain'),
      "snow" => I18n.t('forecaster.snow'),
      "sleet" => I18n.t('forecaster.sleet'),
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
    def daily_forecast_summary
      forecast = daily_forecast
      return unless forecast

      summary = forecast.summary&.downcase&.sub(/\.$/, "")
      temp = if forecast.temperatureMin && forecast.temperatureMax
        I18n.t(
          'forecaster.temp_between',
          min: forecast.temperatureMin.round,
          max: forecast.temperatureMax.round
        )
      end
      precipitations = if forecast.precipType && forecast.precipProbability >= 0.2
        I18n.t(
          'forecaster.precip_robability',
          value: (forecast.precipProbability * 100).round,
          what: PRECIPITATIONS[forecast.precipType]
        )
      end
      pressure = I18n.t(
        'forecaster.pressure',
        value: forecast.pressure.round
      ) if forecast.pressure

      text = [summary, precipitations, temp, pressure].compact.join(", ")
      [text, daily_forecast_icon].compact.join(" ")
    end

    # @return [Array<Integer>] The list of hours that are good for a bike ride
    def good_bike_hours
      hourly_forecast.select do |hour_forecast|
        (!daily_forecast.sunriseTime ||
          !daily_forecast.sunsetTime ||
          hour_forecast.time.between?(
            daily_forecast.sunriseTime,
            daily_forecast.sunsetTime
          )
        ) &&
          good_for_bike?(hour_forecast)
      end.map do |hour_forecast|
        Time.at(hour_forecast.time).hour
      end
    end

    def daily_forecast_icon
      forecast = daily_forecast
      return unless forecast
      ICONS[forecast.icon]
    end

    private

    attr_reader :location_name, :time

    def daily_forecast
      forecast_result.daily.data.first if forecast_result
    end

    def hourly_forecast
      forecast_result.hourly.data if forecast_result
    end

    # @param forecast [Hashie::Mash] An hourly forecast
    def good_for_bike?(forecast)
      (!forecast.temperature || forecast.temperature >= 13) &&
      (!forecast.precipProbability || forecast.precipProbability <= 0.2) &&
      (!forecast.windSpeed || forecast.windSpeed < 30)
    end

    def forecast_result
      @forecast_result ||= begin
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
            lang: I18n.locale.to_s,
            units: "ca",
            exclude: "currently,minutely,alerts,flags"
          }
        )
        unless result
          logger.error("Missing result from ForecastIO") and return
        end
        logger.info(result)
        result
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
