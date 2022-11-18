# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../lib/ai/comparison_responder"

include DialogflowResponses

describe AI::ComparisonResponder do
  describe "#call" do
    it "returns the correct response" do
      responder = AI::ComparisonResponder.new(comparison_response(subjects: ["linux", "windows"]))
      responder.call.must_match(/(linux|windows)/)
    end

    it "returns nil with one subject" do
      responder = AI::ComparisonResponder.new(comparison_response(subjects: ["alone"]))
      responder.call.must_be_nil
    end

    it "returns nil with no subjects" do
      responder = AI::ComparisonResponder.new(comparison_response(subjects: []))
      responder.call.must_be_nil
    end

    it "returns nil with nil subjects" do
      responder = AI::ComparisonResponder.new(comparison_response(subjects: nil))
      responder.call.must_be_nil
    end
  end
end
