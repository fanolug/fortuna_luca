require_relative "../../../../test/test_helper"
require_relative "../cycling"

describe FortunaLuca::Reports::Cycling do
  let(:instance) { FortunaLuca::Reports::Cycling.new(date) }
  let(:date) { Date.new(2023, 1, 5) }

  before do
    ENV["REPORTS_CYCLING_CONFIG"] = '{"12345": "Fano"}'
  end

  describe "#call" do
    it "sends a daily summary" do
      FortunaLuca::Weather::Cycling::DaySummary.any_instance.expects(:call).returns("non fa uscire in bici")
      FortunaLuca::Reports::Cycling.any_instance.expects(:holiday?).returns(true)
      FortunaLuca::Reports::Cycling.any_instance.expects(:welcome).returns("Ciao")
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: "Ciao 🚲\nOggi a Fano non fa uscire in bici\n"
      )
      instance.call
    end
  end
end
