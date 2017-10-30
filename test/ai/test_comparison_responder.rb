require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/comparison_responder"

include ApiaiResponses

describe AI::ComparisonResponder do
  describe "#call" do
    it "returns the correct response" do
      responder = AI::ComparisonResponder.new(comparison_apiai_response)
      responder.call.must_match(/(linux|windows)/)
    end

    it "returns nil with one subject" do
      responder = AI::ComparisonResponder.new(comparison_apiai_response(subjects: ["alone"]))
      responder.call.must_be_nil
    end

    it "returns nil with no subjects" do
      responder = AI::ComparisonResponder.new(comparison_apiai_response(subjects: []))
      responder.call.must_be_nil
    end

    it "returns nil with nil subjects" do
      responder = AI::ComparisonResponder.new(comparison_apiai_response(subjects: nil))
      responder.call.must_be_nil
    end
  end
end
