require "forecast_io"
require "geocoder/configuration"
require "geocoder/logger"
require "geocoder/kernel_logger"
require "geocoder/query"
require "geocoder/lookup"
require "geocoder/exceptions"
require_relative "logging"

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

  def daily_forecast_for(location_name, time)
    initialize_forecastio
    lat, lng = coordinates_for(location_name)
    return unless lat

    forecast = ForecastIO.forecast(
      lat,
      lng,
      time: time.to_i,
      params: {
        lang: "it",
        exclude: "currently,daily,minutely,alerts,flags"
      }
    )

    return "...penso che l'api sia down." if !forecast
    logger.debug(forecast.inspect) if ENV["DEVELOPMENT"]

    icon = FORECAST_ICONS[forecast.dig("hourly", "icon")]
    summary = forecast.dig("hourly", "summary")

    [summary, icon].compact.join(" ")
  end

  private

  def initialize_forecastio
    @initialize_forecastio ||= ForecastIO.api_key = ENV["FORECASTIO_KEY"]
  end

  def coordinates_for(location_name)
    geocoding = Geocoder::Query.new(location_name).execute.first
    return unless geocoding

    [
      geocoding.geometry["location"]["lat"],
      geocoding.geometry["location"]["lng"]
    ]
  end
end
