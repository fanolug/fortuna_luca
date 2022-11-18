require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/twitter"

describe FortunaLuca::Telegram::Twitter do
  let(:tweet) { ::Twitter::Tweet.new(id: 111, created_at: Time.now.to_s, text: "tweet text") }
  let(:tweet2) { ::Twitter::Tweet.new(id: 111, created_at: Time.now.to_s, text: "tweet 2 text") }
  let(:media_tweet) { ::Twitter::Tweet.new(id: 222, created_at: Time.now.to_s, text: "media tweet text") }
  let(:old_tweet) { ::Twitter::Tweet.new(id: 333, created_at: (Time.now - 3600).to_s, text: "old tweet text") }
  let(:media) { Twitter::Media::Photo.new(id: 666, media_url: "https://media.example.com")}

  let(:instance) { FortunaLuca::Telegram::Twitter.new }

  describe "#send_last_tweets" do
    it "sends the last tweets to the configured channels" do
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns([tweet, media_tweet, old_tweet])
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns([tweet2])
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: "tweet text"
      )
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: "media tweet text"
      )
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: "tweet 2 text"
      )
      instance.send_last_tweets
    end
  end

  describe "#send_last_tweets_media" do
    it "sends the last tweets media to the configured channels" do
      media_tweet.stubs(:media).returns([media])

      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns([tweet, media_tweet, old_tweet])
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns([tweet2])
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "67890",
        text: "https://media.example.com"
      )
      instance.send_last_tweets_media
    end
  end
end
