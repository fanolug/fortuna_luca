require_relative "../../../../test/test_helper"
require_relative "../morning"

describe FortunaLuca::Reports::Morning do
  let(:instance) { FortunaLuca::Reports::Morning.new }

  before do
    ENV["REPORTS_MORNING_CONFIG"] = '{"12345": "Fano"}'
  end

  describe '#call' do
    it "sends a daily summary" do
      FortunaLuca::Reports::Morning.any_instance.expects(:good_morning).returns("Buongiorno!")
      FortunaLuca::Weather::DaySummary.any_instance.expects(:coordinates_for).
        with("Fano").
        returns(["43.8441", "13.0170"])
      FortunaLuca::Weather::DaySummary.any_instance.expects(:call).returns("possibilità di pioggia")
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: '12345',
        text: "Buongiorno! Oggi a Fano possibilità di pioggia"
      )
      instance.call
    end
  end
end
