require "dotenv/load"
require "telegram/bot"
require_relative "../logging"

module FortunaLuca
  module Telegram
    module Client
      include Logging

      def send_telegram_message(chat_id, text, **options)
        if text.to_s == ""
          logger.info "Blank message text (#send_telegram_message)"
          return
        end

        begin
          telegram_client.api.send_message(chat_id: chat_id, text: text, **options)
        rescue ::Telegram::Bot::Exceptions::ResponseError => exception
          logger.error "#{exception.message} (#send_telegram_message chat_id: #{chat_id}, text: #{text})"
        end
      end

      private

      def telegram_client(options = {})
        @telegram_client ||= ::Telegram::Bot::Client.new(
          ENV["TELEGRAM_TOKEN"],
          options.merge(logger: logger)
        )
      end
    end
  end
end
