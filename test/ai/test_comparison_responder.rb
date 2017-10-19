require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/comparison_responder"

include ApiaiResponses

describe AI::ComparisonResponder do
  before do
    @responder = AI::ComparisonResponder.new(comparison_apiai_response)
  end

  describe "#call" do
    it "returns the correct response" do
      @responder.call.must_match(/(linux|windows)/)
    end
  end
end
