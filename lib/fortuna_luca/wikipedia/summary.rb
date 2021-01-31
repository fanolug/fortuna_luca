# frozen_string_literal: true

require "httpclient"
require "json"
require_relative "../../logging"

module FortunaLuca
  module Wikipedia
    class Summary
      include Logging

      # @param language [String] A valid Wikipedia language code
      def initialize(language = I18n.locale)
        @api_url = "https://#{language}.wikipedia.org/w/api.php"
      end

      # @param term [String] The term to search
      # @return [String,nil] A short description, if found
      def call(term)
        page = data(term)&.dig("query", "pages")&.min_by { |_, v| v["index"] }
        extract = page.dig(1, "extract") if page
        extract.split("\n").first if extract
      end

      private

      attr_reader :api_url

      def data(term)
        params = {
          "action" => "query",
          "generator" => "prefixsearch",
          "gpssearch" => term,
          "prop" => "extracts",
          "exintro" => 1,
          "redirects" => 1,
          "explaintext" => 1,
          "format" => "json"
        }
        result = HTTPClient.get(api_url, params)
        JSON.parse(result.body)
      rescue JSON::ParserError => e
        logger.error "Wikipedia JSON parse error: #{e.message}"
        nil
      end
    end
  end
end
