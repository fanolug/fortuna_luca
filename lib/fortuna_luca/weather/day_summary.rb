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
            min: data.temperatures.min,
            max: data.temperatures.max
          ),
          I18n.t('weather.day_summary.pressure', value: data.pressure),
          I18n.t('weather.day_summary.humidity', value: data.humidity),
          icons_for(data.codes).join
        ].compact.join
      end

      private

      attr_reader :date, :lat, :lon

      def forecast
        @forecast ||= Weather::Source.new(lat: lat, lon: lon, date: date).call
      end

      def data
        forecast.daily
      end

      def precipitations
        return if data.precipitations.probability < 30

        probability = I18n.t(
          'weather.day_summary.precip_probability',
          value: data.precipitations.probability
        )
        rain = if data.precipitations.rain > 0
          I18n.t('weather.day_summary.rain', value: data.precipitations.rain)
        end
        snow = if data.precipitations.snow > 0
          I18n.t('weather.day_summary.snow', value: data.precipitations.snow)
        end

        [probability, rain, snow].compact.join
      end

      def text_summary
        data.codes.map do |code|
          I18n.t(code, scope: 'weather.codes')
        end.join(", ")
      end
    end
  end
end
