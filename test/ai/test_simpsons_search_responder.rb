# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../lib/ai/simpsons_search_responder"

include DialogflowResponses

describe AI::SimpsonsSearchResponder do
  let(:responder) do
    AI::SimpsonsSearchResponder.new(term_search_response(query: 'canionero'))
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Frinkiac.any_instance.expects(:search_image).with('canionero').returns("Some caption http://example.com")
      responder.call.must_equal("Some caption http://example.com")
    end
  end
end
