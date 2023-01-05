# frozen_string_literal: true

require_relative "../../../../../test/test_helper"
require_relative "../support/dialogflow_responses"
require_relative "../../responders/weather"

include DialogflowResponses

describe FortunaLuca::AI::Responders::Weather do
  let(:responder) { FortunaLuca::AI::Responders::Weather.new(weather_response) }
  let(:datetime) { Time.parse("2021-11-29T12:00:00+01:00") }
  let(:date) { datetime.to_date }

  before do
    FortunaLuca::Weather::DaySummary.any_instance.expects(:coordinates_for).
      with("Fano").
      returns(["43.8441", "13.0170"])
    @forecaster = FortunaLuca::Weather::DaySummary.new(location: "Fano", date: date)
  end

  describe "#call" do
    it "returns the correct response" do
      Time.stub(:now, datetime - 1) do
        FortunaLuca::Weather::DaySummary.expects(:new).with(location: "Fano", date: date).returns(@forecaster)
        @forecaster.expects(:call).returns("poco nuvoloso a partire da sera")
        responder.call.must_equal("Domani a Fano poco nuvoloso a partire da sera")
      end
    end
  end
end
