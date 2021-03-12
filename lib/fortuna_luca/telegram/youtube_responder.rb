# frozen_string_literal: true

require "dotenv/load"
require "feedjira"
require_relative 'client'
require_relative '../../logging'

module FortunaLuca
  module Telegram
    class YoutubeResponder
      include Logging
      include FortunaLuca::Telegram::Client

      # @param data [String] The Youtube Atom feed
      def initialize(data)
        @data = data
      end

      def call
        feed = ::Feedjira.parse(data)
        logger.info(feed)
        result = feed&.entries&.first&.url
        send_telegram_message(chat_id, result)
      rescue Feedjira::NoParserAvailable
      end

      private

      attr_reader :data

      def chat_id
        ENV["TELEGRAM_CHAT_ID_FOR_YT_FEED"]
      end
    end
  end
end
