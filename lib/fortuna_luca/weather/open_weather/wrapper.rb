# frozen_string_literal: true

require_relative "client"
require_relative "../result"
require_relative "../wrapper"

module FortunaLuca
  module Weather
    module OpenWeather
      class Wrapper < Weather::Wrapper
        ICONS = {
          "01" => "\u{2600}", # clear sky
          "02" => "\u{26c5}", # few clouds
          "03" => "\u{2601}", # scattered clouds
          "04" => "\u{2601}", # broken clouds
          "09" => "\u{1f327}", # shower rain
          "10" => "\u{1f327}", # rain
          "11" => "\u{26c8}", # thunderstorm
          "13" => "\u{1f328}", # snow
          "50" => "\u{1f32b}", # mist
        }.freeze

        # @return [Weather::Result]
        def call
          if out_of_range?
            return Weather::Result.new(success: false, error: 'Day is out of range')
          end

          if !data
            return Weather::Result.new(success: false, error: 'Not found')
          end

          Weather::Result.new(
            success: true,
            text_summary: data["weather"].map { |d| d["description"] }.join(", "),
            precipitations: {
              probability: (data["pop"] * 100).round,
              rain: data["rain"]&.round || 0,
              snow: data["snow"]&.round || 0
            },
            temperatures: {
              min: data["temp"]["min"].round,
              max: data["temp"]["max"].round
            },
            wind: {
              speed: data["wind_speed"].round,
              deg: data["wind_deg"],
              gust: data["wind_gust"]&.round
            },
            pressure: data["pressure"],
            humidity: data["humidity"],
            icons: icons
          )
        end

        private

        def response
          Weather::OpenWeather::Client.new.call(lat, lon)
        end

        # API only returns the next 8 days
        def out_of_range?
          date > (Date.today + 8)
        end

        def data
          @data ||= response["daily"].find do |day|
            Time.at(day["dt"]).to_date == date
          end
        end

        def icons
          data["weather"].map do |d|
            icon_number = d["icon"].delete("^0-9")
            ICONS[icon_number]
          end.uniq
        end
      end
    end
  end
end
