# frozen_string_literal: true

require_relative "report"
require_relative "../weather/detailed_day_summary"

module FortunaLuca
  module Reports
    class Morning
      include Report

      private

      def message(location)
        <<~TEXT
          #{I18n.t("reports.today_in")} #{location} #{daily_forecast(location)}
        TEXT
      end

      def daily_forecast(location)
        Weather::DetailedDaySummary.new(
          location: location,
          date: date,
          show_commuting: !holiday? && !weekend?
        ).call
      end

      # JSON Config format: {"chat_id":"location name"}
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_MORNING_CONFIG"))
      end
    end
  end
end
