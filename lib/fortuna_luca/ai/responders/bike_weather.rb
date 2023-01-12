require_relative "weather"
require_relative "../../weather/cycling"

module FortunaLuca
  module AI
    module Responders
      class BikeWeather < Weather
        private

        def daily_forecast
          @daily_forecast ||= FortunaLuca::Weather::Cycling.new(
            location: weather_city,
            date: weather_time.to_date
          ).call
        end
      end
    end
  end
end
