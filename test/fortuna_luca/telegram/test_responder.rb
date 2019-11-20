require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/responder"

describe FortunaLuca::Telegram::Responder do
  let(:telegram_message) { ::Telegram::Bot::Types::Message.new(message_attributes) }
  let(:instance) { FortunaLuca::Telegram::Responder.new(telegram_message) }

  describe "#call" do
    describe "with a messages that is not matching regexps" do
      let(:message_attributes) { { text: "a random message", chat: { id: 123 } } }

      it "sends a telegram API request with AI response" do
        AI::Responder.any_instance.expects(:call).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call
      end
    end

    describe "with a /xkcd command" do
      let(:message_attributes) { { text: "/xkcd", chat: { id: 123 } } }

      it "sends a telegram API request with a XCD response" do
        Xkcd.any_instance.expects(:random_image).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call
      end
    end

    describe "with a /comics command" do
      let(:message_attributes) { { text: "/comics", chat: { id: 123 } } }

      it "sends a telegram API request with a XCD response" do
        Xkcd.any_instance.expects(:random_image).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call
      end
    end

    describe "with a /google command" do
      let(:message_attributes) { { text: "/google something", chat: { id: 123 } } }

      it "sends a telegram API request with a WebSearcher response" do
        WebSearcher.any_instance.expects(:first_link).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call
      end
    end
  end
end
