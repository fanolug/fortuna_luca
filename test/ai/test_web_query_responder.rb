require_relative "../test_helper"
require_relative "../support/apiai_responses"
require_relative "../../lib/ai/weather_responder"

include ApiaiResponses

describe AI::WebQueryResponder do
  before do
    @responder = AI::WebQueryResponder.new(web_query_apiai_response)
  end

  describe "#call" do
    it "returns the correct response" do
      WebSearcher.any_instance.
                  expects(:first_link).
                  returns("http://www.fanolug.org/")
      @responder.call.must_equal("http://www.fanolug.org/")
    end
  end
end
