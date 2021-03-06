require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/responder"

describe FortunaLuca::Telegram::Responder do
  let(:telegram_message) { ::Telegram::Bot::Types::Message.new(message_attributes) }
  let(:instance) { FortunaLuca::Telegram::Responder.new(telegram_message) }

  describe "#call" do
    describe "with a message that is not including the bot name" do
      let(:message_attributes) { { text: "Some message", chat: { id: 123 } } }

      it "just returns false" do
        AI::Responder.any_instance.expects(:call).never
        Telegram::Bot::Api.any_instance.expects(:send_message).never
        instance.call.must_equal(false)
      end
    end

    describe "with a message that is including the bot name" do
      let(:message_attributes) do
        {
          text: "@fortuna_luca some questions",
          chat: { id: 123 },
        }
      end

      it "removes the bot name from the message" do
        ai_instance = AI::Responder.new("some questions")
        AI::Responder.expects(:new).with("some questions").returns(ai_instance)
        AI::Responder.any_instance.stubs(:call)
        Telegram::Bot::Api.any_instance.stubs(:send_message)
        instance.call
      end

      it "sends a telegram API request with AI response" do
        AI::Responder.any_instance.expects(:call).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call.must_equal(true)
      end
    end

    describe "with a private message" do
      let(:message_attributes) do
        {
          text: "some message",
          chat: { id: 123, type: "private" },
        }
      end

      it "sends a telegram API request with AI response" do
        AI::Responder.any_instance.expects(:call).returns("the response")
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: 123, text: "the response" }
        )
        instance.call.must_equal(true)
      end
    end
  end
end
