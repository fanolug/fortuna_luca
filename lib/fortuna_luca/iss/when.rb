# frozen_string_literal: true

require "i18n"
require "httpclient"
require "json"
require_relative "../../logging"

module FortunaLuca
  module Iss
    class When
      include Logging
      
      DEFAULT_LAT = 43.8789729
      DEFAULT_LON = 12.9601665
      DEFAULT_NUMBER = 5
      
      def initialize(lat = DEFAULT_LAT, lon = DEFAULT_LON, number = DEFAULT_NUMBER)
        @api_url = "http://api.open-notify.org/iss-pass.json?lat=#{lat}&lon=#{lon}&n=#{number}"
      end

      def call
        result = HTTPClient.get(@api_url)
        response = JSON.parse(result.body)["response"][0]
        message(response)
      rescue JSON::ParserError => e
        Logging.logger.error "Iss JSON parse error: #{e.message}"
        nil
      end
      
      private

      def message(response)
        duration_min = response["duration"] / 60 
        date_time = Time.at(response["risetime"]).getlocal
        date = date_time.strftime("%d/%m")
        hour = date_time.strftime("%H:%M")
        I18n.t('iss.pass_time', date: date, hour: hour, duration_min: duration_min) 
      end
    end
  end
end
