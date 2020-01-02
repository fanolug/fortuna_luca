require_relative "dialogflow_responder"
require_relative "../forecaster"

module AI
  class WeatherResponder
    include DialogflowResponder

    DEFAULT_CITY = "Fano"

    def call
      city = weather_city
      forecast = Forecaster.new.daily_forecast_for(city, weather_time)
      return if !forecast

      context = response.dig(:result, :contexts).find do |c|
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

    def weather_time
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

    def weather_city
      address = response.dig(:result, :parameters, :address)
      city = address.respond_to?(:dig) ? address.dig(:city) : address
      city = DEFAULT_CITY if !city || city == ""
      city
    end
  end
end
