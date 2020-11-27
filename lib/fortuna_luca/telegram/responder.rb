# frozen_string_literal: true

require "dotenv/load"
require_relative 'client'
require_relative '../../logging'
require_relative '../../xkcd'
require_relative '../../ai/responder'

module FortunaLuca
  module Telegram
    class Responder
      include Logging
      include FortunaLuca::Telegram::Client

      # @param message [Telegram::Bot::Types::Message] The Telegram message
      def initialize(message)
        @message = message
      end

      def call
        return false if !private? && !mention?

        send_telegram_message(chat_id, AI::Responder.new(clean_text).call)
        true
      end

      private

      attr_reader :message

      def chat_id
        message.chat.id
      end

      def mention?
        message.text.to_s.include?(ENV["TELEGRAM_BOT_NAME"].to_s)
      end

      def private?
        message.chat&.type == "private"
      end

      def clean_text
        message.
          text.
          to_s.
          gsub(ENV["TELEGRAM_BOT_NAME"].to_s, "").
          tr("\n", ' ').
          squeeze(' ').
          strip
      end
    end
  end
end
