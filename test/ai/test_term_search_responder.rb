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
      FortunaLuca::Wikipedia::Summary.any_instance.expects(:call).returns("The response")
      @responder.call.must_equal("The response")
    end

    it "fall backs on web search" do
      FortunaLuca::Wikipedia::Summary.any_instance.expects(:call).returns(nil)
      WebSearcher.any_instance.expects(:first_link).returns("https://it.wikipedia.org/wiki/Linux")
      @responder.call.must_equal("https://it.wikipedia.org/wiki/Linux")
    end
  end
end
