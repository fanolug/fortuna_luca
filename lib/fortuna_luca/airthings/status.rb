# frozen_string_literal: true

module FortunaLuca
  module Airthings
    module Status
      include FortunaLuca::Telegram::Client

      # order matters
      SUPPORTED_KEYS = %w[temp humidity voc radonShortTermAvg co2 mold].freeze
      UNITS = {
        "co2" => "ppm",
        "humidity" => "%",
        "mold" => "/10",
        "radonShortTermAvg" => "Bq/m³",
        "temp" => "°",
        "voc" => "ppb",
      }.freeze
      RANGES = {
        "co2" => { green: 0, yellow: 800, red: 1000 },
        "humidity" => { green: 30, yellow: 60, red: 70 },
        "radonShortTermAvg" => { green: 0, yellow: 100, red: 150 },
        "voc" => { green: 0, yellow: 250, red: 2000 },
      }.freeze
      ICONS = {
        green: "\u{1F7E2}",
        yellow: "\u{1F7E1}",
        red: "\u{1F534}"
      }

      # @return [String] HTML status of all the sensors
      def airthings_status
        data = airthings_client.samples
        longest_room_name = data.map { |room, _| room.size }.max

        data.map do |room, samples|
          name_padding = " " * (longest_room_name - room.size)

          formatted_samples = samples.slice(*SUPPORTED_KEYS).map do |key, value|
            format_sample(key, value)
          end.join(", ")


          "<pre>#{room}:#{name_padding} #{formatted_samples}</pre>"
        end.join("\n")
      end

      private

      def airthings_client
        @airthings_client ||= Airthings::Client.new
      end

      def color(key, value)
        ranges = RANGES[key]
        return :unknown unless ranges

        case value
          when -Float::INFINITY...ranges[:green] then :yellow
          when ranges[:green]...ranges[:yellow] then :green
          when ranges[:yellow]...ranges[:red] then :yellow
          else :red
        end
      end

      def icon(key, value)
        ICONS[color(key, value)]
      end

      def format_sample(key, value, icon: true)
        [
          I18n.t(key, scope: :airthings, default: ''),
          "#{"%g" % value}#{UNITS[key]}",
          (icon(key, value) if icon)
        ].compact.join(" ").strip
      end
    end
  end
end
