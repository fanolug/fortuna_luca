# frozen_string_literal: true

require "dotenv/load"
require "i18n"
require_relative 'client'
require_relative '../logging'

module FortunaLuca
  module Telegram
    class Quakes
      include Logging
      include FortunaLuca::Telegram::Client

      # @param data [String] The Strava webhook payload
      def initialize(events)
        @events = events
      end

      def call
        events.each do |event|
          chat_ids.each do |chat_id|
            send_telegram_message(
              chat_id,
              event_message(event),
              disable_web_page_preview: true
            )
          end
        end
      end

      private

      attr_reader :events

      def event_message(event)
        time = event.time.to_time.getlocal(ENV['TIMEZONE']).strftime("%F %T")

        [
          I18n.t('quakes.earthquake_icon'),
          " ",
          I18n.t('quakes.earthquake'),
          "!" * event.magnitude.to_f.round,
          " M#{event.magnitude} ",
          event.description,
          " - #{time}: ",
          event.url
        ].join
      end

      def chat_ids
        ENV["QUAKES_CHAT_IDS"].split(",")
      end
    end
  end
end
