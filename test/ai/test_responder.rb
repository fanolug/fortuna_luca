require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/responder"

include ApiaiResponses

describe AI::Responder do
  before do
    @responder = AI::Responder.new("some input")
  end

  describe "#call" do
    it "returns the correct response" do
      ApiAiRuby::Client.any_instance.
                        expects(:text_request).
                        returns(simple_apiai_response)
      @responder.call.must_equal("Cià")
    end
  end
end
