# frozen_string_literal: true

module FortunaLuca
  module AI
    module Responders
      class Weather < Base
        DEFAULT_CITY = "Fano"
        CONTEXT_NAME = "weather"

        def call
          return if !daily_forecast

          [
            time_in_words,
            I18n.t('responders.at_location', where: weather_city),
            daily_forecast
          ].compact.join(" ")
        end

        private

        def daily_forecast
          @daily_forecast ||= FortunaLuca::Weather::DetailedDaySummary.new(
            location: weather_city,
            date: weather_time.to_date
          ).call
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
            time = Time.parse(date_string.to_s)
            time < now ? now : time
          rescue ArgumentError => e
            logger.debug("Invalid date string '#{date_string}': #{e.message}")
            now
          end
        end

        def address
          result.parameters&.fields["address"]&.struct_value&.fields
        end

        def weather_city
          return DEFAULT_CITY unless address

          city = address["city"]&.string_value
          city.to_s == "" ? DEFAULT_CITY : city
        end
      end
    end
  end
end
