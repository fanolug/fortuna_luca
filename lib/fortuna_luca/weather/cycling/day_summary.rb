# frozen_string_literal: true

require_relative "hours"
require_relative "../icons"

module FortunaLuca
  module Weather
    module Cycling
      class DaySummary < Hours
        include Icons

        # @param location [String]
        # @param date [Date]
        def initialize(location:, date:)
          @location = location
          @date = date
        end

        # @return [String]
        def call
          return I18n.t("weather.cycling.ko") if good_hours_data.none?

          <<~TEXT
            #{I18n.t("weather.cycling.ok")} #{hours_text}! #{icons}
            #{temperatures_text}
            #{wind_text}
          TEXT
        end

        private

        attr_reader :location, :date

        def good_hours_data
          @good_hours_data ||= Hours.new(location: location, date: date).call
        end

        def grouped_good_hours
          good_hours_data
            .map { |data| Time.at(data.time).hour }
            .sort
            .slice_when { |previous, current| previous.next != current }
            .to_a
        end

        def hours_text
          grouped_good_hours.map do |group|
            group = [group].flatten
            I18n.t(
              "weather.cycling.between_hours",
              start: group.first,
              end: group.last.next
            )
          end.join(", ")
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
