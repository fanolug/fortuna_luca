require "forecast_io"
require "geocoder/configuration"
require "geocoder/logger"
require "geocoder/kernel_logger"
require "geocoder/query"
require "geocoder/lookup"
require "geocoder/exceptions"

module Forecast
  def summary_forecast_for(location_name, time)
    initialize_forecastio
    lat, lng = coordinates_for(location_name)
    return unless lat

    forecast = ForecastIO.forecast(
      lat,
      lng,
      time: time.to_i,
      params: { lang: "it" }
    )

    logger.debug(forecast.inspect) if ENV["DEVELOPMENT"]
    forecast.dig("daily", "data", 0, "summary")
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
