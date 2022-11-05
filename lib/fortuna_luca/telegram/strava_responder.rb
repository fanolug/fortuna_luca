# frozen_string_literal: true

require "dotenv/load"
require "json"
require_relative 'client'
require_relative '../logging'

module FortunaLuca
  module Telegram
    class StravaResponder
      include Logging
      include FortunaLuca::Telegram::Client

      # @param data [String] The Strava feed
      def initialize(data)
        @data = data
      end

      def call
        message = JSON.parse(data)
        logger.info(message)
      end

      private

      attr_reader :data

      def chat_id
        ENV["STRAVA_CHAT_ID"]
      end
    end
  end
end
