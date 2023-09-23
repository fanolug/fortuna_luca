# frozen_string_literal: true

module FortunaLuca
  module Reports
    class AllertaMeteo
      include Reports::Report

      def call
        return unless show?

        config.each do |chat_id|
          send_telegram_message(chat_id, message) if message
        end

        true
      end

      private

      def message
        return unless tomorrow_entry

        [
          "⚠️ #{tomorrow_entry.title}",
          tomorrow_entry.summary,
          tomorrow_entry.links.first
        ].join("\n")
      end

      def tomorrow_entry
        @tomorrow_entry ||= feed_entries.find do |entry|
          entry.title.match?(/^Allerta .* valida .* #{date.strftime("%d-%m-%Y")}/)
        end
      end

      def feed_entries
        FortunaLuca::Weather::AllertaMeteo::Client.new.call
      end

      # JSON Config format: ["chat_id"]
      def config
        @config ||= JSON.parse(env_or_blank("REPORTS_ALLERTA_METEO_CONFIG"))
      end
    end
  end
end
