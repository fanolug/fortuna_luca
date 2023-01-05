# frozen_string_literal: true

require "httpclient"
require "json"
require "dotenv/load"
require_relative "../../../../config/i18n"
require_relative "../../logging"

module FortunaLuca
  module Weather
    module TomorrowIO
      class Client
        include Logging

        URL = "https://api.tomorrow.io/v4/timelines"

        # @param lat [String]
        # @param lon [String]
        # @return [Hash] The API result
        def call(lat, lon)
          args = default_args.merge(location: [lat, lon].join(","))
          response = HTTPClient.get(URL, args)
          logger.info response.body
          JSON.parse(response.body)
        end

        private

        def default_args
          {
            apikey: ENV["TOMORROWIO_TOKEN"],
            fields: %w[
              precipitationIntensity
              precipitationType
              precipitationProbability
              windSpeed
              windGust
              windDirection
              weatherCode
              weatherCodeFullDay
              temperature
              temperatureApparent
              humidity
              pressureSeaLevel
              cloudCover
              cloudBase
              cloudCeiling
              weatherCode
            ],
            timesteps: "1h,1d",
            units: "metric",
            timezone: ENV['TIMEZONE']
          }
        end
      end
    end
  end
end
