require "dotenv/load"
require "google/cloud/dialogflow/v2"
require "securerandom"

require_relative "../logging"
require_relative "responders/weather"
require_relative "responders/bike_weather"
require_relative "responders/web_query"
require_relative "responders/comparison"
require_relative "responders/term_search"
require_relative "responders/simpsons_search"
require_relative "responders/airthings"

module FortunaLuca
  module AI
    class Responder
      include Google::Cloud::Dialogflow::V2::Sessions::Paths
      include FortunaLuca::Logging

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
        when "weather" then Responders::Weather.new(result).call
        when "bike_weather" then Responders::BikeWeather.new(result).call
        when "web_query" then Responders::WebQuery.new(result).call
        when "comparison" then Responders::Comparison.new(result).call
        when "term_search" then Responders::TermSearch.new(result).call
        when "simpsons_search" then Responders::SimpsonsSearch.new(result).call
        when "airthings" then Responders::Airthings.new.call
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
end
