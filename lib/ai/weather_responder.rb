require_relative "../logging"
require_relative "../forecaster"

module AI
  class WeatherResponder
    include Logging

    DEFAULT_CITY = "Fano"

    def initialize(apiai_response)
      @response = apiai_response
    end

    def call
      city = parse_weather_city(@response)
      time = parse_weather_time(@response)
      forecast = Forecaster.new.daily_forecast_for(city, time)
      return if !forecast

      context = @response.dig(:result, :contexts).find do |c|
        c[:name] == "weather"
      end
      time_in_words = if context
        context.dig(:parameters, :"date-time.original")
      end

      [
        time_in_words&.capitalize,
        "a #{city}",
        forecast.downcase
      ].compact.join(" ")
    end

    private

    def parse_weather_time(response)
      date_string = response.dig(:result, :parameters, :"date-time")
      now = Time.now

      begin
        date = Time.parse(date_string.to_s)
        date < now ? now : date
      rescue ArgumentError => e
        logger.debug("Invalid date string '#{date}': #{e.message}")
        now
      end
    end

    def parse_weather_city(response)
      address = response.dig(:result, :parameters, :address)
      city = address.respond_to?(:dig) ? address.dig(:city) : address
      city = DEFAULT_CITY if !city || city == ""
      city
    end
  end
end
