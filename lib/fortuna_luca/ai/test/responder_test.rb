# frozen_string_literal: true

require_relative "../../../../test/test_helper"
require_relative "support/dialogflow_responses"

include DialogflowResponses

describe FortunaLuca::AI::Responder do
  let(:responder) { FortunaLuca::AI::Responder.new("ciao") }

  before do
    stub_request(:post, "https://oauth2.googleapis.com/token").to_return(
      status: 200,
      body: "",
      headers: {
        content_type: "application/x-www-form-urlencoded"
      }
    )
  end

  # describe "#call" do
  #   it "returns the correct response" do
  #     Google::Cloud::Dialogflow::V2::Sessions::Client.any_instance.
  #       expects(:detect_intent).
  #       returns(direct_response)
  #     responder.call.must_equal("Buongiorno")
  #   end
  # end
end
