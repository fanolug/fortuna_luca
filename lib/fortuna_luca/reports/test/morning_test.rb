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
      FortunaLuca::Forecaster.any_instance.expects(:daily_forecast_summary).returns(
        "possibilità di pioggia"
      )
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: '12345',
        text: "Buongiorno! Oggi a Fano possibilità di pioggia"
      )
      instance.call
    end
  end
end
