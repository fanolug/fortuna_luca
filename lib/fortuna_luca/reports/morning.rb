# frozen_string_literal: true

require 'date'
require_relative "../../../config/i18n"
require_relative "../telegram/client"
require_relative "../weather/day_summary"
require_relative "../logging"

module FortunaLuca
  module Reports
    class Morning
      include Logging
      include FortunaLuca::Telegram::Client

      def call
        config.each do |chat_id, location|
          send_telegram_message(chat_id, message(location))
        end

        true
      end

      private

      def message(location)
        [
          good_morning,
          I18n.t('reports.today'),
          I18n.t('reports.in'),
          location,
          daily_forecast(location),
        ].join(" ")
      end

      def good_morning
        I18n.t('reports.good_mornings').sample
      end

      def daily_forecast(location)
        Weather::DaySummary.new(location: location, date: Date.today).call
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
