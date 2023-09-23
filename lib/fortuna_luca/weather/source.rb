# frozen_string_literal: true

module FortunaLuca
  module Weather
    class Source
      # @param lat [String]
      # @param lon [String]
      # @param date [Date]
      def initialize(lat:, lon:, date:)
        @lat = lat
        @lon = lon
        @date = date
      end

      # @return [Weather::Forecast]
      def call
        Weather::OpenWeather::Wrapper.new(lat: lat, lon: lon, date: date).call
      end

      private

      attr_reader :lat, :lon, :date
    end
  end
end
