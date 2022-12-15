# frozen_string_literal: true

require_relative "../../../config/i18n"
require_relative "../telegram/client"
require_relative "client"

module FortunaLuca
  module Airthings
    module Status
      include FortunaLuca::Telegram::Client

      KEYS = %w[humidity radonShortTermAvg temp voc].freeze
      UNITS = {
        "humidity" => "%",
        "radonShortTermAvg" => " Bq/m³",
        "temp" => "°",
        "voc" => " ppb"
      }.freeze

      # @return [String] Human-readabale status of all the sensors
      def airthings_status
        airthings_client.samples.map do |room, samples|
          formatted_samples = samples.slice(*KEYS).map do |key, value|
            formatted_value = "#{"%g" % value}#{UNITS[key]}"
            [I18n.t(key, scope: :airthings), formatted_value].join(" ")
          end.join(", ")

          [room, formatted_samples].join(": ")
        end.join("\n")
      end

      private

      def airthings_client
        @airthings_client ||= Airthings::Client.new
      end
    end
  end
end
