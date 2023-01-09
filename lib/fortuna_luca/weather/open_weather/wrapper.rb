# frozen_string_literal: true

require_relative "client"
require_relative "../types/forecast"
require_relative "../wrapper"

module FortunaLuca
  module Weather
    module OpenWeather
      class Wrapper < Weather::Wrapper
        CODES = {
          200 => %i[thunderstorm light_rain], # thunderstorm with light rain
          201 => :thunderstorm, # thunderstorm with rain
          202 => %i[thunderstorm heavy_rain], # thunderstorm with heavy rain
          210 => :thunderstorm, # light thunderstorm
          211 => :thunderstorm, # thunderstorm
          212 => %i[thunderstorm heavy_rain], # heavy thunderstorm
          221 => :thunderstorm, # ragged thunderstorm
          230 => :thunderstorm, # thunderstorm with light drizzle
          231 => :thunderstorm, # thunderstorm with drizzle
          232 => :thunderstorm, # thunderstorm with heavy drizzle
          300 => :drizzle, # light intensity drizzle
          301 => :drizzle, # drizzle
          302 => :rain, # heavy intensity drizzle
          310 => :drizzle, # light intensity drizzle rain
          311 => :drizzle, # drizzle rain
          312 => :heavy_rain, # heavy intensity drizzle rain
          313 => :rain, # shower rain and drizzle
          314 => :heavy_rain, # heavy shower rain and drizzle
          321 => :rain, # shower drizzle
          500 => :light_rain, # light rain
          501 => :rain, # moderate rain
          502 => :heavy_rain, # heavy intensity rain
          503 => :heavy_rain, # very heavy rain
          504 => :heavy_rain, # extreme rain
          511 => :freezing_rain, # freezing rain
          520 => :light_rain, # light intensity shower rain
          521 => :rain, # shower rain
          522 => :heavy_rain, # heavy intensity shower rain
          531 => :rain, # ragged shower rain
          600 => :light_snow, # light snow
          601 => :snow, # Snow
          602 => :heavy_snow, # Heavy snow
          611 => :sleet, # Sleet
          612 => :sleet, # Light shower sleet
          613 => :sleet, # Shower sleet
          615 => :sleet, # Light rain and snow
          616 => :sleet, # Rain and snow
          620 => :light_snow, # Light shower snow
          621 => :snow, # Shower snow
          622 => :heavy_snow, # Heavy shower snow
          701 => :fog, # mist
          711 => :fog, # Smoke
          721 => :fog, # Haze
          731 => :sand, # sand/ dust whirls
          741 => :fog, # fog
          751 => :sand, # sand
          761 => :sand, # dust
          762 => :sand, # volcanic ash
          771 => :squalls, # squalls
          781 => :tornado, # tornado
          800 => :clear, # clear sky
          801 => :mostly_clear, # few clouds: 11-25%
          802 => :partly_cloudy, # scattered clouds: 25-50%
          803 => :mostly_cloudy, # broken clouds: 51-84%
          804 => :cloudy, # overcast clouds: 85-100%
        }.freeze

        # @return [Weather::Forecast]
        def call
          if out_of_range?
            return Weather::Forecast.new(success: false, error: 'Day is out of range')
          end

          if !daily_data
            return Weather::Forecast.new(success: false, error: 'Not found')
          end

          Weather::Forecast.new(
            success: true,
            daily: mapping(daily_data),
            hourly: response["hourly"].map { |data| mapping(data) }
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

        def daily_data
          @daily_data ||= response["daily"].find do |day|
            Time.at(day["dt"]).to_date == date
          end
        end

        def mapping(data)
          {
            time: data["dt"],
            codes: data["weather"].flat_map { |d| CODES[d["id"]] },
            text_summary: data["weather"].map { |d| d["description"] }.join(", "),
            precipitations: {
              probability: (data["pop"] * 100).round,
              rain: precipitation(data, "rain"),
              snow: precipitation(data, "snow")
            },
            temperatures: {
              min: temperature(data, "min"),
              max: temperature(data, "max")
            },
            wind: {
              speed: data["wind_speed"].round,
              deg: data["wind_deg"],
              gust: data["wind_gust"]&.round
            },
            pressure: data["pressure"],
            humidity: data["humidity"],
          }
        end

        def temperature(data, type)
          (data["temp"].respond_to?(:round) ? data["temp"] : data["temp"][type]).round
        end

        def precipitation(data, type)
          return 0 unless data[type]
          return data[type].round if data[type]&.respond_to?(:round)
          (data[type]["1h"] * 100).round
        end
      end
    end
  end
end
