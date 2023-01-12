# frozen_string_literal: true

require_relative "morning"
require_relative "../weather/cycling"

module FortunaLuca
  module Reports
    class Cycling < Morning
      private

      def daily_forecast(location)
        Weather::Cycling.new(location: location, date: date).call
      end

      # JSON Config format: {"chat_id":"location name"}
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_CYCLING_CONFIG"))
      end

      def show_today?
        holiday?
      end
    end
  end
end
