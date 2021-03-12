# frozen_string_literal: true

require "dotenv/load"
require "feedjira"
require_relative '../../logging'

module FortunaLuca
  module Telegram
    class YoutubeResponder
      include Logging

      # @param data [String] The Youtube Atom feed
      def initialize(data)
        @data = data
      end

      def call
        feed = ::Feedjira.parse(data)
        logger.info(feed)
        feed&.entries&.first&.url
      rescue Feedjira::NoParserAvailable
      end

      private

      attr_reader :data
    end
  end
end
