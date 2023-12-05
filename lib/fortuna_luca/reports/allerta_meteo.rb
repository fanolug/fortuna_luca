# frozen_string_literal: true

module FortunaLuca
  module Reports
    class AllertaMeteo
      include Reports::Report
      include FortunaLuca::ProcessedIDs

      def initialize; end

      def call
        return unless show?
        return unless message

        process_once(latest_alert.id) do
          config.each do |chat_id|
            send_telegram_message(chat_id, message, parse_mode: "HTML")
          end
        end

        true
      end

      private

      def message
        return unless latest_alert

        [
          "⚠️ <b>#{latest_alert.title}</b>",
          latest_alert.summary,
          latest_alert.links.first
        ].join("\n")
      end

      def latest_alert
        @latest_alert ||= feed_entries.find do |entry|
          entry.title.start_with?('Allerta')
        end
      end

      def feed_entries
        FortunaLuca::Weather::AllertaMeteo::Client.new.call
      end

      # JSON Config format: ["chat_id"]
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_ALLERTA_METEO_CONFIG"))
      end

      def processed_ids_redis_key
        "allerta_meteo"
      end
    end
  end
end
