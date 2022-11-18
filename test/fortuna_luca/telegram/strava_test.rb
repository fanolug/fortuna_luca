require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/strava"

describe FortunaLuca::Telegram::Strava do
  let(:instance) { FortunaLuca::Telegram::Strava.new(data) }

  describe "#call" do
    describe "with a created activity message" do
      let(:data) do
        '{"aspect_type": "create", "event_time": 1667648440, "object_id": 111111, "object_type": "activity", "owner_id": 2222222, "subscription_id": 333333, "updates": {}}'
      end

      it "sends the link on the channel" do
        ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
          chat_id: "12345",
          text: "https://www.strava.com/activities/111111"
        )
        instance.call
      end
    end
  end
end
