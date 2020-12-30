require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/weather_responder"

include ApiaiResponses

describe AI::WeatherResponder do
  before do
    @responder = AI::WeatherResponder.new(weather_apiai_response)
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Forecaster.any_instance.
                 expects(:daily_forecast_summary).
                 returns("poco nuvoloso a partire da sera")
      @responder.call.must_equal("Domani a Fano poco nuvoloso a partire da sera")
    end
  end
end
