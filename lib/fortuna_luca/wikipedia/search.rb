# frozen_string_literal: true
require 'httpclient'
require 'multi_json'
require_relative "../../logging"

module FortunaLuca
  module Wikipedia
    class Summary
      include Logging

      def initialize
        API_URL = "https://it.wikipedia.org/w/api.php" 
        client = HTTPClient.new
      end

      # @param term [String]
      # @return [String,nil]
      def call(term)
        params = { 
            'action' => 'opensearch', 
            'search' => term, 
            'limit' => 1, 
            'namespace' => 0, 
            'format' => 'json' 
        }
        page = client.get(API_URL, params)
        link = MultiJson.load(page.body)[3][0]
      end
    end
  end
end