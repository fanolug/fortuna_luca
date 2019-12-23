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
        # clean up text
        text = message.text.to_s.tr("\n", ' ').squeeze(' ').strip

        case text
        # display a XKCD comic
        when /^\/(xkcd|comics)/i # /xkcd or /comics
          send_telegram_message(chat_id, Xkcd.new.random_image)
        # get the first web search result link
        when /^\/google (.+)/i # /google
          send_telegram_message(chat_id, WebSearcher.new($1).first_link)
        # default: try AI to generate some response
        else
          text = text.sub(/\A\/\S* /, "") # remove /command part
          send_telegram_message(chat_id, AI::Responder.new(text).call)
        end

        true
      end

      private

      attr_reader :message

      def chat_id
        message.chat.id
      end
    end
  end
end
