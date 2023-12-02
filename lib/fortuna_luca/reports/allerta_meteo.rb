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

        process_once(last_entry.id) do
          config.each do |chat_id|
            send_telegram_message(chat_id, message, parse_mode: "HTML")
          end
        end

        true
      end

      private

      def message
        return unless last_entry

        [
          "⚠️ <b>#{last_entry.title}</b>",
          last_entry.summary,
          last_entry.links.first
        ].join("\n")
      end

      def last_entry
        @last_entry ||= feed_entries.max_by(&:id)
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
