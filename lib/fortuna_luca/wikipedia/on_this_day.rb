# frozen_string_literal: true

require "i18n"
require "httpclient"
require "json"
require_relative "../logging"

module FortunaLuca
  module Wikipedia
    class OnThisDay
      include Logging

      # @param language [String] A valid Wikipedia language code
      def initialize(language = I18n.locale)
        @api_url = "https://api.wikimedia.org/feed/v1/wikipedia/#{language}/onthisday"
      end

      # @param month [String] Zero-padded month, 01 through 12
      # @param day [String] Zero-padded day of the month, 01 through 31
      # @param type [String] Type of event:
      #   all: Returns all types
      #   selected: Curated set of events that occurred on the given date
      #   births: Notable people born on the given date
      #   deaths: Notable people who died on the given date
      #   holidays: Fixed holidays celebrated on the given date
      #   events: Events that occurred on the given date that are not included in another type
      # @return [Array<Hash>] The response items
      def call(month:, day:, type:)
        url = "#{api_url}/#{type}/#{month}/#{day}"
        response = HTTPClient.get(url)
        data = JSON.parse(response.body)
        return if !data || !data[type]
        data[type]
      rescue JSON::ParserError => e
        logger.error "Wikipedia JSON parse error: #{e.message}"
        nil
      end

      private

      attr_reader :api_url
    end
  end
end
