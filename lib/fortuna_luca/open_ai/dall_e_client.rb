# frozen_string_literal: true

module FortunaLuca
  module OpenAI
    class DallEClient < ChatGPTClient
      # @param content [String] The input
      # @return [String] The response
      def call(content)
        response = get_response(content)
        if error = response.dig("error", "message")
          logger.error(error)
        else
          response.dig("data", 0, "url")
        end
      end

      private

      def get_response(content)
        client.images.generate(parameters: { prompt: content })
      end
    end
  end
end
