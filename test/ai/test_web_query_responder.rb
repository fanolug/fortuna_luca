# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../lib/ai/web_query_responder"

include DialogflowResponses

describe AI::WebQueryResponder do
  let(:responder) { AI::WebQueryResponder.new(web_query_response(query: "fanolug")) }

  before do
    @searcher = WebSearcher.new(query: "result for fanolug")
  end

  describe "#call" do
    it "returns the correct response" do
      WebSearcher.expects(:new).with(query: "result for fanolug").returns(@searcher)
      @searcher.expects(:first_link).returns("http://www.fanolug.org/")
      responder.call.must_equal("http://www.fanolug.org/")
    end
  end
end
