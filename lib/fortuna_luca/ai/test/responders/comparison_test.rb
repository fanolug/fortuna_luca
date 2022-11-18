# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../responders/comparison"

include DialogflowResponses

describe FortunaLuca::AI::Responders::Comparison do
  describe "#call" do
    it "returns the correct response" do
      responder = FortunaLuca::AI::Responders::Comparison.new(comparison_response(subjects: ["linux", "windows"]))
      responder.call.must_match(/(linux|windows)/)
    end

    it "returns nil with one subject" do
      responder = FortunaLuca::AI::Responders::Comparison.new(comparison_response(subjects: ["alone"]))
      responder.call.must_be_nil
    end

    it "returns nil with no subjects" do
      responder = FortunaLuca::AI::Responders::Comparison.new(comparison_response(subjects: []))
      responder.call.must_be_nil
    end

    it "returns nil with nil subjects" do
      responder = FortunaLuca::AI::Responders::Comparison.new(comparison_response(subjects: nil))
      responder.call.must_be_nil
    end
  end
end
