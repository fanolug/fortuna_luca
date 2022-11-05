# frozen_string_literal: true

require "dotenv/load"
require "json"
require_relative 'client'
require_relative '../logging'

module FortunaLuca
  module Telegram
    class Strava
      include Logging
      include FortunaLuca::Telegram::Client

      # @param data [String] The Strava webhook payload
      def initialize(data)
        @data = data
      end

      def call
        message = JSON.parse(data)
        logger.info(message)
        handle_message(message)
      end

      private

      attr_reader :data

      def activity_url(activity_id)
        "https://www.strava.com/activities/#{activity_id}"
      end

      def handle_message(message)
        case message["object_type"]
        when "activity"
          case message["aspect_type"]
          when "create"
            send_telegram_message(ENV["STRAVA_CHAT_ID"], activity_url(message["object_id"]))
          end
        end
      end
    end
  end
end
