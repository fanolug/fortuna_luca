# frozen_string_literal: true

require "dotenv/load"
require "json"
require "strava-ruby-client"
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
        payload = JSON.parse(data)
        logger.info(payload)
        event = ::Strava::Webhooks::Models::Event.new(payload)
        handle_event(event)
      end

      private

      attr_reader :data

      def activity_url(activity_id)
        "https://www.strava.com/activities/#{activity_id}"
      end

      def handle_event(event)
        case event.object_type
        when "activity"
          case event.aspect_type
          when "create"
            send_telegram_message(ENV["STRAVA_CHAT_ID"], activity_url(event.object_id))
          end
        end
      end
    end
  end
end
