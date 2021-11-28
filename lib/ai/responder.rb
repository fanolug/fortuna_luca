require "dotenv/load"
require "google/cloud/dialogflow/v2"
require "securerandom"
require_relative "../logging"
require_relative "weather_responder"
require_relative "bike_weather_responder"
require_relative "web_query_responder"
require_relative "comparison_responder"
require_relative "term_search_responder"
require_relative "simpsons_search_responder"

module AI
  class Responder
    include Google::Cloud::Dialogflow::V2::Sessions::Paths
    include Logging

    def initialize(input)
      @input = input
    end

    def call
      result = dialogflow.detect_intent(
        session: dialogflow_session,
        query_input: {
          text: {
            text: @input,
            language_code: ENV['DIALOGFLOW_LANGUAGE_CODE']
          }
        }
      )
      logger.debug(result.inspect)
      handle_ai_result(result.query_result)
    end

    private

    # @param result [Google::Cloud::Dialogflow::V2::QueryResult]
    def handle_ai_result(result)
      # when a direct text result is available
      text = result.fulfillment_text
      return text if text && text != ""

      # when no direct text result is available
      case result.action
      when "weather" then WeatherResponder.new(result).call
      when "bike_weather" then BikeWeatherResponder.new(result).call
      when "web_query" then WebQueryResponder.new(result).call
      when "comparison" then ComparisonResponder.new(result).call
      when "term_search" then TermSearchResponder.new(result).call
      when "simpsons_search" then SimpsonsSearchResponder.new(result).call
      else
        # TODO nothing?
      end
    end

    def dialogflow
      @dialogflow ||= Google::Cloud::Dialogflow::V2::Sessions::Client.new
    end

    def dialogflow_session
      session_path(project: ENV["GOOGLE_CLOUD_PROJECT_ID"], session: SecureRandom.hex)
    end
  end
end
