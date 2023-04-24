# frozen_string_literal: true

require_relative "../../geo"
require_relative "../icons"
require_relative "../source"

module FortunaLuca
  module Weather
    module Cycling
      class DaySummary
        include Geo
        include Icons

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
          return false if good_hours_data.none?

          <<~TEXT
            #{I18n.t("weather.cycling.ok")} #{hours_text}! #{icons}
            #{temperatures_text}
            #{wind_text}
          TEXT
        end

        private

        attr_reader :date, :lat, :lon

        def forecast
          @forecast ||= Weather::Source.new(lat: lat, lon: lon, date: date).call
        end

        def good_hours_data
          @good_hours_data ||=
            forecast.hourly.select do |data|
              time = Time.at(data.time)

              time.to_date == date &&
                time.hour.between?(START_HOUR, END_HOUR) && good_for_bike?(data)
            end
        end

        def grouped_good_hours
          good_hours_data
            .map { |data| Time.at(data.time).hour }
            .sort
            .slice_when { |previous, current| previous.next != current }
            .to_a
        end

        def good_for_bike?(data)
          data.temperatures.min > MIN_TEMP &&
            data.precipitations.probability < MAX_PRECIPITATION_PROBABILITY &&
            data.wind.speed < MAX_WIND_SPEED
        end

        def hours_text
          grouped_good_hours
            .map do |group|
              group = [group].flatten
              I18n.t(
                "weather.cycling.between_hours",
                start: group.first,
                end: group.last.next
              )
            end
            .join(", ")
        end

        def temperatures_text
          I18n.t(
            "weather.cycling.temp_between",
            min: good_hours_data.map { |d| d.temperatures.min }.min,
            max: good_hours_data.map { |d| d.temperatures.max }.max
          )
        end

        def wind_text
          return if max_wind_speed < 5

          I18n.t("weather.cycling.wind", value: max_wind_speed)
        end

        def max_wind_speed
          good_hours_data.map { |d| d.wind.speed }.max
        end

        def icons
          icons_for(good_hours_data.flat_map(&:codes)).uniq.join
        end
      end
    end
  end
end
