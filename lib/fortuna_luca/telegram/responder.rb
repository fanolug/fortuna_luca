# frozen_string_literal: true

require 'dotenv'
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
        Dotenv.load
        @message = message
      end

      def call
        return false unless mention?

        text = message.text.to_s.tr("\n", ' ').squeeze(' ').strip
        send_telegram_message(chat_id, AI::Responder.new(text).call)
        true
      end

      private

      attr_reader :message

      def chat_id
        message.chat.id
      end

      def mention?
        message.entities.any? { |entity| entity.type == "mention" }
      end
    end
  end
end
