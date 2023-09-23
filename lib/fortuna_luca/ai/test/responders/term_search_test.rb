# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../support/dialogflow_responses"

include DialogflowResponses

describe FortunaLuca::AI::Responders::TermSearch do
  let(:responder) { FortunaLuca::AI::Responders::TermSearch.new(term_search_response(query: 'linux')) }

  before do
    @searcher = FortunaLuca::WebSearcher.new(query: "linux", site: "it.wikipedia.org")
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
      FortunaLuca::WebSearcher.expects(:new).with(query: "linux", site: "it.wikipedia.org").returns(@searcher)
      @searcher.expects(:first_link).returns("https://it.wikipedia.org/wiki/Linux")
      responder.call.must_equal("https://it.wikipedia.org/wiki/Linux")
    end
  end
end
