# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../lib/ai/weather_responder"

include DialogflowResponses

describe AI::WeatherResponder do
  let(:responder) { AI::WeatherResponder.new(weather_response) }
  let(:date) { Time.parse("2021-11-29T12:00:00+01:00") }

  before do
    @forecaster = FortunaLuca::Forecaster.new("Fano", date)
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Forecaster.expects(:new).with("Fano", date).returns(@forecaster)
      @forecaster.expects(:daily_forecast_summary).returns("poco nuvoloso a partire da sera")
      responder.call.must_equal("Domani a Fano poco nuvoloso a partire da sera")
    end
  end
end
