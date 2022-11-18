require_relative "weather"

module FortunaLuca
  module AI
    module Responders
      class BikeWeather < Weather
        def call
          good_hours = forecaster.good_bike_hours
          if good_hours.none?
            return I18n.t(
              'responders.bike_weather.not_good_for_ride',
              when: time_in_words,
              where: weather_city
            )
          end

          grouped_good_hours = good_hours.sort.slice_when do |previous, current|
            previous.next != current
          end.to_a

          good_hours_in_words = grouped_good_hours.map.with_index(1) do |group, index|
            group = [group].flatten
            I18n.t(
              'responders.bike_weather.between_hours',
              start: group.first,
              end: group.last.next
            )
          end.join(", ")

          [
            time_in_words,
            I18n.t('responders.at_location', where: weather_city),
            I18n.t('responders.bike_weather.good_for_ride'),
            good_hours_in_words,
            forecaster.daily_forecast_icon
          ].compact.join(" ")
        end
      end
    end
  end
end
