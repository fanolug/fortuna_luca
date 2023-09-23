# frozen_string_literal: true

require "date"
require "holidays"

module FortunaLuca
  module Reports
    module Report
      include Logging
      include FortunaLuca::Telegram::Client

      # @param [Date] date
      def initialize(date)
        @date = date
      end

      def call
        return unless show?

        config.each do |chat_id, subject|
          message = message(subject)
          next unless message

          send_telegram_message(chat_id, message)
        end

        true
      end

      private

      attr_reader :date

      def message(subject)
        raise NotImplementedError
      end

      def config
        raise NotImplementedError
      end

      def env_or_blank(key)
        ENV[key] || "{}"
      end

      def holiday?
        Holidays.on(date, :it).any?
      end

      def weekend?
        date.saturday? || date.sunday?
      end

      def show?
        true
      end
    end
  end
end
