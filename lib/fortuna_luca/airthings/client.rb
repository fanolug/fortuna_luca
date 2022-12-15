# frozen_string_literal: true

require "oauth2"
require "httpclient"
require "dotenv/load"

module FortunaLuca
  module Airthings
    class Client
      URL = "https://ext-api.airthings.com/v1"

      # @return [Hash] The list of device sensor samples
      def samples
        devices.select do |device|
          device.dig("deviceType") != "HUB"
        end.map do |device|
          [device.dig("segment", "name"), device_samples(device.dig("id"))]
        end.to_h
      end

      private

      def devices
        response = get("/devices")
        JSON.parse(response.body).dig("devices")
      end

      def device_samples(serial_number)
        response = get("/devices/#{serial_number}/latest-samples")
        JSON.parse(response.body).dig("data")
      end

      def oauth_client
        @oauth_client ||= OAuth2::Client.new(
          ENV['AIRTHINGS_CLIENT_ID'],
          ENV['AIRTHINGS_CLIENT_SECRET'],
          authorize_url: "https://accounts.airthings.com/authorize",
          token_url: "https://accounts-api.airthings.com/v1/token"
        )
      end

      def oauth_token
        oauth_client.client_credentials.get_token.token
      end

      def get(path)
        HTTPClient.get("#{URL}#{path}", {}, { "Authorization" => oauth_token })
      end
    end
  end
end
