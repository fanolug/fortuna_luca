require "i18n"
require_relative "dialogflow_responder"
require_relative "../fortuna_luca/forecaster"

module AI
  class WeatherResponder
    include DialogflowResponder

    DEFAULT_CITY = "Fano"
    CONTEXT_NAME = "weather"

    def call
      forecast = forecaster.daily_forecast_summary
      return if !forecast

      [
        time_in_words,
        I18n.t('responders.at_location', where: weather_city),
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

    def weather_context
      result.output_contexts.find do |context|
        context.name.end_with? "/contexts/#{CONTEXT_NAME}"
      end
    end

    def time_in_words
      if weather_context
        weather_context.parameters.fields["date-time.original"].string_value&.capitalize
      end
    end

    def weather_time
      date_string = result.parameters.fields["date-time"].string_value
      now = Time.now

      begin
        date = Time.parse(date_string.to_s)
        date < now ? now : date
      rescue ArgumentError => e
        logger.debug("Invalid date string '#{date}': #{e.message}")
        now
      end
    end

    def address
      result.parameters&.fields["address"]&.struct_value&.fields
    end

    def weather_city
      city = address["city"]&.string_value
      city = DEFAULT_CITY if !city || city == ""
      city
    end
  end
end
