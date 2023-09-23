# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../support/dialogflow_responses"

include DialogflowResponses

describe FortunaLuca::AI::Responders::WebQuery do
  let(:responder) { FortunaLuca::AI::Responders::WebQuery.new(web_query_response(query: "fanolug")) }

  before do
    @searcher = FortunaLuca::WebSearcher.new(query: "result for fanolug")
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::WebSearcher.expects(:new).with(query: "result for fanolug").returns(@searcher)
      @searcher.expects(:first_link).returns("http://www.fanolug.org/")
      responder.call.must_equal("http://www.fanolug.org/")
    end
  end
end
