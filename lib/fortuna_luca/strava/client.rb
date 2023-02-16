# frozen_string_literal: true

require "dotenv/load"
require "strava-ruby-client"

module FortunaLuca
  module Strava
    module Client
      def strava_client
        ::Strava::Api::Client.new(access_token: access_token)
      end

      private

      def oauth_client
        @oauth_client ||= ::Strava::OAuth::Client.new(
          client_id: ENV["STRAVA_CLIENT_ID"],
          client_secret: ENV["STRAVA_CLIENT_SECRET"]
        )
      end

      def access_token
        response = oauth_client.oauth_token(
          refresh_token: ENV["STRAVA_REFRESH_TOKEN"],
          grant_type: 'refresh_token'
        )

        response.access_token
      end
    end
  end
end
