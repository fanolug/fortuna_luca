require "dotenv/load"
require "api-ai-ruby"
require_relative "../logging"
require_relative "weather_responder"
require_relative "bike_weather_responder"
require_relative "web_query_responder"
require_relative "comparison_responder"
require_relative "term_search_responder"
require_relative "simpsons_search_responder"

module AI
  class Responder
    include Logging

    def initialize(input)
      @input = input
    end

    def call
      begin
        response = dialogflow_client.text_request(@input)
        logger.debug(response.inspect)
        handle_ai_response(response)
      rescue ApiAiRuby::ClientError, ApiAiRuby::RequestError => e
        "Dialogflow error: #{e.message}"
      end
    end

    private

    def dialogflow_client
      @dialogflow_client ||= ApiAiRuby::Client.new(
        client_access_token: ENV["APIAI_TOKEN"],
        api_lang: ENV["APIAI_LANG"]
      )
    end

    def handle_ai_response(response)
      # when a direct speech response is available
      speech = response.dig(:result, :fulfillment, :speech)
      return speech if speech && speech != ""

      # when no speech response is available
      case response.dig(:result, :action)
      when "weather" then WeatherResponder.new(response).call
      when "bike_weather" then BikeWeatherResponder.new(response).call
      when "web_query" then WebQueryResponder.new(response).call
      when "comparison" then ComparisonResponder.new(response).call
      when "term_search" then TermSearchResponder.new(response).call
      when "simpsons_search" then SimpsonsSearchResponder.new(response).call
      else
        # TODO nothing?
      end
    end
  end
end
