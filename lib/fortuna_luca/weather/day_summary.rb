# frozen_string_literal: true

require_relative "../geo"
require_relative "icons"
require_relative "source"

module FortunaLuca
  module Weather
    class DaySummary
      include Geo
      include Icons

      # @param location [String]
      # @param date [Date]
      def initialize(location:, date:)
        @date = date
        @lat, @lon = coordinates_for(location)
      end

      def call
        [
          text_summary,
          precipitations,
          I18n.t(
            'weather.day_summary.temp_between',
            min: result.temperatures[:min],
            max: result.temperatures[:max]
          ),
          I18n.t('weather.day_summary.pressure', value: result.pressure),
          I18n.t('weather.day_summary.humidity', value: result.humidity),
          icons_for(result.codes).join
        ].compact.join
      end

      private

      attr_reader :date, :lat, :lon

      def result
        @result ||= Weather::Source.new(lat: lat, lon: lon, date: date).call
      end

      def precipitations
        return if result.precipitations[:probability] < 30

        probability = I18n.t(
          'weather.day_summary.precip_probability',
          value: result.precipitations[:probability]
        )
        rain = if result.precipitations[:rain] > 0
          I18n.t('weather.day_summary.rain', value: result.precipitations[:rain])
        end
        snow = if result.precipitations[:snow] > 0
          I18n.t('weather.day_summary.snow', value: result.precipitations[:snow])
        end

        [probability, rain, snow].compact.join
      end

      def text_summary
        result.codes.map do |code|
          I18n.t(code, scope: 'weather.codes')
        end.join(", ")
      end
    end
  end
end
