# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../../responders/airthings"

describe FortunaLuca::AI::Responders::Airthings do
  let(:responder) { FortunaLuca::AI::Responders::Airthings.new }

  describe "#call" do
    it "returns the correct response" do
      FortunaLuca::AI::Responders::Airthings.any_instance.expects(
        :airthings_status
      ).returns("The response")
      responder.call.must_equal("The response")
    end
  end
end
