# frozen_string_literal: true

require "httpclient"
require "json"
require "dotenv/load"
require_relative "../../../../config/i18n"
require_relative "../../logging"

module FortunaLuca
  module Weather
    module OpenWeather
      class Client
        include Logging

        URL = "https://api.openweathermap.org/data/3.0/onecall"

        # @param lat [String]
        # @param lon [String]
        # @return [Hash] The API result
        def call(lat, lon)
          args = default_args.merge(lat: lat, lon: lon)
          response = HTTPClient.get(URL, args)
          logger.info response.body
          JSON.parse(response.body)
        end

        private

        def default_args
          {
            appid: ENV["OPENWEATHER_API_KEY"],
            exclude: "minutely",
            units: "metric",
            lang: I18n.locale.to_s
          }
        end
      end
    end
  end
end
