# frozen_string_literal: true

module FortunaLuca
  module Weather
    # Base wrapper class to be extended by specific service wrappers
    class Wrapper
      # @param lat [String]
      # @param lon [String]
      # @param date [Date]
      def initialize(lat:, lon:, date:)
        @lat = lat
        @lon = lon
        @date = date
      end

      # @return [Weather::Result]
      def call
        raise NotImplementedError, "#call must be implemented"
      end

      private

      attr_reader :lat, :lon, :date
    end
  end
end
