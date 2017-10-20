require_relative "test_helper"
require_relative "../lib/bot"

describe Bot do
  before do
    @bot = Bot.new
  end

  describe "#run!" do
    before do
      Process.stubs(:daemon)
    end

    it "sets process name" do
      @bot.stubs(:run_telegram_loop)
      Process.expects(:setproctitle)
      @bot.run!
    end

    it "daemonize process" do
      @bot.stubs(:run_telegram_loop)
      Process.expects(:daemon).with(true, true)
      @bot.run!
    end

    it "starts a Telegram connection" do
      Telegram::Bot::Client.any_instance.expects(:run)
      @bot.run!
    end
  end

  describe "#send_message" do
    it "sends the api request" do
      Telegram::Bot::Api.any_instance.expects(:send_message).with(
        { chat_id: 123, text: "some text" }
      )
      @bot.send_message(123, "some text")
    end
  end

  describe "#send_message_parsemode" do
    it "sends the api request" do
      Telegram::Bot::Api.any_instance.expects(:send_message_parsemode).with(
        { chat_id: 123, text: "some text", parse_mode: 'Markdown' }
      )
      @bot.send_message(123, "some text")
    end
  end

  describe "#tweet!" do
    it "sends the api request" do
      twitter_result = mock()
      twitter_result.stubs(:url).returns("https://twitter.com/fanolug/status/123")
      Twitter::REST::Client.any_instance.expects(:update).with(
        "the text [the username]"
      ).returns(twitter_result)

      result = @bot.tweet!("the username", "the text")
      result.must_equal("https://twitter.com/fanolug/status/123")
    end
  end
end
