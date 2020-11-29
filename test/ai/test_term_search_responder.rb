require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/term_search_responder"

include ApiaiResponses

describe AI::TermSearchResponder do
  before do
    @responder = AI::TermSearchResponder.new(term_search_apiai_response)
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Wikipedia::Summary.any_instance.
                  expects(:call).
                  returns("The response")
      @responder.call.must_equal("The response")
    end
  end
end
