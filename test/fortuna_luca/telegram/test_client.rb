require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/client"

describe FortunaLuca::Telegram::Client do
  let(:instance) { Class.new { include FortunaLuca::Telegram::Client }.new }

  describe "#send_telegram_message" do
    it "calls the Telegram API" do
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: '123',
        text: 'the text'
      )
      instance.send_telegram_message('123', 'the text')
    end

    describe "with some options" do
      it "passes them to the Telegram API" do
        ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
          chat_id: '123',
          text: 'the text',
          disable_web_page_preview: true
        )
        instance.send_telegram_message('123', 'the text', disable_web_page_preview: true)
      end
    end
  end
end
