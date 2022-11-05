# frozen_string_literal: true

require "dotenv/load"
require "json"
require_relative "client"
require_relative "../twitter/client"
require_relative "../../logging"

module FortunaLuca
  module Telegram
    class Twitter
      include Logging
      include FortunaLuca::Telegram::Client
      include FortunaLuca::Twitter::Client

      def send_last_tweets(minutes: 60)
        follow_config.each do |telegram_chat_id, handles|
          handles.each do |handle|
            tweets_for_last_minutes(handle: handle, minutes: minutes).each do |tweet|
              send_telegram_message(telegram_chat_id, tweet.text)
            end
          end
        end
      end

      def send_last_tweets_media(minutes: 60)
        media_follow_config.each do |telegram_chat_id, handles|
          handles.each do |handle|
            media_for_last_minutes(handle: handle, minutes: minutes).each do |media_url|
              send_telegram_message(telegram_chat_id, media_url)
            end
          end
        end
      end

      private

      # TWITTER_FOLLOW_CONFIG and TWITTER_MEDIA_FOLLOW_CONFIG have the
      # following JSON structure:
      #
      # {
      #   "TELEGRAM_CHANNEL_1_ID": ["@twitter_handle, @twitter_handle2"],
      #   "TELEGRAM_CHANNEL_2_ID": ["@twitter_handle ,@twitter_handle3"]
      # }

      def follow_config
        @follow_config ||= JSON.parse(env_or_blank("TWITTER_FOLLOWS"))
      end

      def media_follow_config
        @media_follow_config ||= JSON.parse(env_or_blank("TWITTER_MEDIA_FOLLOWS"))
      end

      def env_or_blank(key)
        ENV[key] || "{}"
      end
    end
  end
end
