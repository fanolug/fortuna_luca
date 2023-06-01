# frozen_string_literal: true

require "openai"
require "json"
require_relative "../logging"

module FortunaLuca
  module OpenAI
    class ChatGPTClient
      def initialize
        configure!
      end

      # @param content [String] The input
      # @return [String] The response
      def call(content)
        response = get_response(content)
        if error = response.dig("error", "message")
          logger.error(error)
        else
          response.dig("choices", 0, "message", "content")
        end
      end

      private

      def configure!
        ::OpenAI.configure do |config|
          config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
          config.organization_id = ENV["OPENAI_ORGANIZATION_ID"]
          config.request_timeout = 60
        end
      end

      def client
        @client ||= ::OpenAI::Client.new
      end

      def get_response(content)
        client.chat(
          parameters: {
            model: ENV["OPENAI_MODEL"],
            messages: [
              { role: "user", content: content }
            ],
            temperature: 0.7,
          }
        )
      end
    end
  end
end
