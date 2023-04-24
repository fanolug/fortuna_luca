# frozen_string_literal: true

require_relative "morning"
require_relative "../weather/cycling/day_summary"

module FortunaLuca
  module Reports
    class Cycling < Morning
      private

      def message(location)
        forecast = daily_forecast(location)
        return unless forecast

        <<~TEXT
          #{welcome} 🚲
          #{I18n.t("reports.today_in")} #{location} #{forecast}
        TEXT
      end

      def daily_forecast(location)
        Weather::Cycling::DaySummary.new(location: location, date: date).call
      end

      # JSON Config format: {"chat_id":"location name"}
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_CYCLING_CONFIG"))
      end

      def show?
        holiday? || weekend?
      end

      def welcome
        I18n.t("reports.cycling.welcomes").sample
      end
    end
  end
end
