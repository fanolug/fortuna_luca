# frozen_string_literal: true

require "dotenv/load"
require "feedjira"
require_relative "client"
require_relative "../logging"
require_relative "../processed_ids"

module FortunaLuca
  module Telegram
    class YoutubeResponder
      include Logging
      include FortunaLuca::Telegram::Client
      include FortunaLuca::ProcessedIDs

      # @param data [String] The Youtube Atom feed
      def initialize(data)
        @data = data
      end

      def call
        feed = ::Feedjira.parse(data)
        logger.info(feed)
        feed.entries&.each do |entry|
          next unless process_id!(entry.entry_id)

          chats_for(entry.youtube_channel_id).each do |chat_id|
            send_telegram_message(chat_id, entry.url)
          end
        end
      rescue Feedjira::NoParserAvailable => error
        logger.error(error.message)
      end

      private

      attr_reader :data

      def processed_ids_redis_key
        "processed_youtube_ids"
      end

      def chats_for(youtube_channel_id)
        JSON.parse(env_or_blank("YOUTUBE__#{youtube_channel_id}"))
      end

      def env_or_blank(key)
        ENV[key] || "[]"
      end
    end
  end
end
