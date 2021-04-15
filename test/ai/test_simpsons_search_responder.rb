require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/simpsons_search_responder"

include ApiaiResponses

describe AI::SimpsonsSearchResponder do
  before do
    @responder = AI::SimpsonsSearchResponder.new(term_search_apiai_response)
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Frinkiac.any_instance.expects(:search_image).returns("Some caption http://example.com")
      @responder.call.must_equal("Some caption http://example.com")
    end
  end
end
