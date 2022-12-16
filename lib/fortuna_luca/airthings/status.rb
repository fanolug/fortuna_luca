# frozen_string_literal: true

require_relative "../../../config/i18n"
require_relative "../telegram/client"
require_relative "client"

module FortunaLuca
  module Airthings
    module Status
      include FortunaLuca::Telegram::Client

      KEYS = %w[temp humidity radonShortTermAvg voc mold].freeze
      UNITS = {
        "temp" => "°",
        "humidity" => "%",
        "radonShortTermAvg" => " Bq/m³",
        "voc" => " ppb",
        "mold" => "/10"
      }.freeze
      RANGES = {
        "humidity" => { low: 30, high: 55, highest: 70 },
        "radonShortTermAvg" => { low: 0, high: 100, highest: 150 },
        "voc" => { low: 0, high: 250, highest: 2000 },
      }.freeze

      # @return [String] Human-readabale status of all the sensors
      def airthings_status
        airthings_client.samples.map do |room, samples|
          formatted_samples = samples.slice(*KEYS).map do |key, value|
            formatted_value = "#{"%g" % value}#{UNITS[key]}"
            [
              I18n.t(key, scope: :airthings),
              formatted_value,
              icon(key, value)
            ].join(" ").strip
          end.join(", ")

          ["*#{room}*", formatted_samples].join(": ")
        end.join("\n")
      end

      private

      def airthings_client
        @airthings_client ||= Airthings::Client.new
      end

      def icon(key, value)
        ranges = RANGES[key]
        return unless ranges

        case value
        when -Float::INFINITY..ranges[:low] then "\u{1F7E1}"
        when ranges[:low]..ranges[:high] then "\u{1F7E2}"
        when ranges[:high]..ranges[:highest] then "\u{1F7E1}"
        when ranges[:highest]..Float::INFINITY then "\u{1F534}"
        end
      end
    end
  end
end
