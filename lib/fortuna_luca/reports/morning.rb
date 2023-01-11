# frozen_string_literal: true

require 'date'
require_relative "../../../config/i18n"
require_relative "../telegram/client"
require_relative "../weather/detailed_day_summary"
require_relative "../logging"

module FortunaLuca
  module Reports
    class Morning
      include Logging
      include FortunaLuca::Telegram::Client

      # @param [Date] date
      def initialize(date)
        @date = date
      end

      def call
        config.each do |chat_id, location|
          send_telegram_message(chat_id, message(location))
        end

        true
      end

      private

      attr_reader :date

      def message(location)
        <<~TEXT
          #{I18n.t('reports.today_in')} #{location} #{daily_forecast(location)}
        TEXT
      end

      def daily_forecast(location)
        Weather::DetailedDaySummary.new(location: location, date: date).call
      end

      # JSON Config format: {"chat_id":"location name"}
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_MORNING_CONFIG"))
      end

      def env_or_blank(key)
        ENV[key] || "{}"
      end
    end
  end
end
