# frozen_string_literal: true

require "dotenv/load"
require "twitter"

module FortunaLuca
  module Twitter
    module Client
      # @param text [String] The tweet content
      # @return [String] The tweet URL, if successful, or an error message
      def tweet!(text)
        begin
          tweet = client.update(text)
          tweet.url.to_s
        rescue ::Twitter::Error => exception
          exception.message
        end
      end

      def tweets(handle:, params: {})
        client.user_timeline(handle, default_twitter_params.merge(params))
      end

      def tweets_for_last_minutes(handle:, minutes:, params: {})
        tweets(handle: handle, params: params).take_while do |tweet|
          Time.now - tweet.created_at <= minutes * 60
        end
      end

      def media_for_last_minutes(handle:, minutes:, params: {})
        tweets_for_last_minutes(handle: handle, minutes: minutes, params: params).map do |tweet|
          tweet.media&.first&.media_url&.to_s
        end.compact
      end

      def followed_twitter_handlers
        ENV["TWITTER_HANDLERS"].split(",").map(&:strip)
      end

      private

      def client
        @client ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
          config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
          config.access_token = ENV["TWITTER_TOKEN"]
          config.access_token_secret = ENV["TWITTER_TOKEN_SECRET"]
        end
      end

      def default_twitter_params
        { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
      end
    end
  end
end
