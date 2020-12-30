require_relative "dialogflow_responder"
require_relative "../fortuna_luca/forecaster"

module AI
  class WeatherResponder
    include DialogflowResponder

    DEFAULT_CITY = "Fano"
    CONTEXT_NAME = "weather"

    def call
      forecast = forecaster.daily_forecast
      return if !forecast

      [
        time_in_words,
        "a #{weather_city}",
        forecast
      ].compact.join(" ")
    end

    private

    def forecaster
      @forecaster ||= FortunaLuca::Forecaster.new(
        weather_city,
        weather_time
      )
    end

    def context
      response.dig(:result, :contexts).find do |c|
        c[:name] == CONTEXT_NAME
      end
    end

    def time_in_words
      if context
        context.dig(:parameters, :"date-time.original").capitalize
      end
    end

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
