# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../lib/ai/term_search_responder"

include DialogflowResponses

describe AI::TermSearchResponder do
  let(:responder) { AI::TermSearchResponder.new(term_search_response(query: 'linux')) }

  before do
    @searcher = WebSearcher.new(query: "linux", site: "it.wikipedia.org")
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Wikipedia::Summary.any_instance.expects(:call).with("linux").returns(
        "The response"
      )
      responder.call.must_equal("The response")
    end

    it "fall backs on web search" do
      FortunaLuca::Wikipedia::Summary.any_instance.expects(:call).returns(nil)
      WebSearcher.expects(:new).with(query: "linux", site: "it.wikipedia.org").returns(@searcher)
      @searcher.expects(:first_link).returns("https://it.wikipedia.org/wiki/Linux")
      responder.call.must_equal("https://it.wikipedia.org/wiki/Linux")
    end
  end
end
