# frozen_string_literal: true

require_relative "../../../config/i18n"
require_relative "../telegram/client"
require_relative "client"

module FortunaLuca
  module Airthings
    module Status
      include FortunaLuca::Telegram::Client

      # order matters
      SUPPORTED_KEYS = %w[temp humidity co2 radonShortTermAvg voc mold].freeze
      UNITS = {
        "co2" => "ppm",
        "humidity" => "%",
        "mold" => "/10",
        "radonShortTermAvg" => " Bq/m³",
        "temp" => "°",
        "voc" => " ppb",
      }.freeze
      RANGES = {
        "co2" => { green: 0, yellow: 1000, red: 2000 },
        "humidity" => { green: 30, yellow: 55, red: 70 },
        "radonShortTermAvg" => { green: 0, yellow: 100, red: 150 },
        "voc" => { green: 0, yellow: 250, red: 2000 },
      }.freeze

      # @return [String] Human-readabale status of all the sensors
      def airthings_status
        data = airthings_client.samples
        longest_room_name = data.map { |room, _| room.size }.max

        data.map do |room, samples|
          name_padding = " " * (longest_room_name - room.size)

          formatted_samples = samples.slice(*SUPPORTED_KEYS).map do |key, value|
            formatted_value = "#{"%g" % value}#{UNITS[key]}"
            [
              I18n.t(key, scope: :airthings),
              formatted_value,
              icon(key, value)
            ].join(" ").strip
          end.join(", ")


          "<pre>#{room}:#{name_padding} #{formatted_samples}</pre>"
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
          when -Float::INFINITY..ranges[:green] then "\u{1F7E1}"
          when ranges[:green]..ranges[:yellow] then "\u{1F7E2}"
          when ranges[:yellow]..ranges[:red] then "\u{1F7E1}"
          else "\u{1F534}"
        end
      end
    end
  end
end
