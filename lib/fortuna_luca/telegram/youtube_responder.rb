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
        feed.entries&.each do |entry|
          next if entry.updated && entry.updated != entry.published

          if chat_id = ENV["YOUTUBE__#{entry.youtube_channel_id}"]
            send_telegram_message(chat_id, entry.url)
          end
        end
      rescue Feedjira::NoParserAvailable => error
        logger.error(error.message)
      end

      private

      attr_reader :data
    end
  end
end
