# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../responders/simpsons_search"

include DialogflowResponses

describe FortunaLuca::AI::Responders::SimpsonsSearch do
  let(:responder) do
    FortunaLuca::AI::Responders::SimpsonsSearch.new(term_search_response(query: 'canionero'))
  end

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::Frinkiac.any_instance.expects(:search_image).with('canionero').returns("Some caption http://example.com")
      responder.call.must_equal("Some caption http://example.com")
    end
  end
end
