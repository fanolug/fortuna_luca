# frozen_string_literal: true

module FortunaLuca
  module Weather
    module Cycling
      class Hours
        include Geo

        START_HOUR = 7
        END_HOUR = 19
        MIN_TEMP = 0
        MAX_PRECIPITATION_PROBABILITY = 35
        MAX_WIND_SPEED = 50

        # @param location [String]
        # @param date [Date]
        def initialize(location:, date:)
          @date = date
          @lat, @lon = coordinates_for(location)
        end

        # @return [String]
        def call
          forecast.hourly.select do |data|
            time = Time.at(data.time)

            time.to_date == date &&
              time.hour.between?(START_HOUR, END_HOUR) && good_for_bike?(data)
          end
        end

        private

        attr_reader :date, :lat, :lon

        def forecast
          @forecast ||= Weather::Source.new(lat: lat, lon: lon, date: date).call
        end

        def good_for_bike?(data)
          data.temperatures.min > MIN_TEMP &&
            data.precipitations.probability < MAX_PRECIPITATION_PROBABILITY &&
            data.wind.speed < MAX_WIND_SPEED
        end
      end
    end
  end
end
