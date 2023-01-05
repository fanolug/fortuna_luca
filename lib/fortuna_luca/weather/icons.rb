# frozen_string_literal: true

module FortunaLuca
  module Weather
    module Icons
      ICONS = {
        thunderstorm: %w[🌩],
        drizzle: %w[🌦],
        rain: %w[🌧],
        heavy_rain: %w[🌧🌧],
        light_rain: %w[🌦],
        freezing_rain: %w[🌦⛄],
        light_snow: %w[🌨],
        snow: %w[🌨⛄],
        heavy_snow: %w[🌨🌨],
        sleet: %w[🌨],
        fog: %w[🌫],
        sand: %w[⏳],
        squalls: %w[🌪],
        tornado: %w[🌪],
        clear: %w[🌞],
        mostly_clear: %w[🌞🌤],
        partly_cloudy: %w[🌤],
        mostly_cloudy: %w[🌥],
        cloudy: %w[☁],
      }.freeze

      def icons_for(weather_codes)
        weather_codes.flat_map { |code| ICONS[code] }.compact
      end
    end
  end
end
