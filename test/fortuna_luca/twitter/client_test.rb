require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/twitter/client"

describe FortunaLuca::Twitter::Client do
  let(:instance) { Class.new { include FortunaLuca::Twitter::Client }.new }
  let(:tweet) do
    ::Twitter::Tweet.new(
      id: 111,
      user: { id: 666, screen_name: "@fanolug" },
      created_at: Time.now.to_s
    )
  end
  let(:media_tweet) { ::Twitter::Tweet.new(id: 222, created_at: Time.now.to_s) }
  let(:old_tweet) { ::Twitter::Tweet.new(id: 333, created_at: (Time.now - 3600).to_s) }
  let(:media) { Twitter::Media::Photo.new(id: 666, media_url: "https://media.example.com")}
  let(:tweets) { [tweet, media_tweet, old_tweet] }

  describe "#tweet!" do
    it "calls the Twitter API" do
      ::Twitter::REST::Client.any_instance.stubs(:update).with("the message").returns(tweet)
      instance.tweet!("the message")
    end

    it "returns the tweet URL" do
      ::Twitter::REST::Client.any_instance.stubs(:update).returns(tweet)
      instance.tweet!("the message").must_equal("https://twitter.com/@fanolug/status/111")
    end

    it "returns the error message on error" do
      ::Twitter::REST::Client.any_instance.stubs(:update).raises(
        ::Twitter::Error.new("the error message")
      )
      instance.tweet!("the message").must_equal("the error message")
    end
  end

  describe "#tweets" do
    it "calls the Twitter API with the default params" do
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).with(
        "@fanolug",
        { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
      )
      instance.tweets(handle: "@fanolug")
    end

    it "can override the params" do
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).with(
        "@fanolug",
        { count: 1, trim_user: true, exclude_replies: true, include_rts: true }
      )
      instance.tweets(handle: "@fanolug", params: { count: 1 })
    end
  end

  describe "#tweets_for_last_minutes" do
    it "returns in-range tweets" do
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns(tweets)
      instance.tweets_for_last_minutes(handle: "@fanolug", minutes: 30).must_equal(
        [tweet, media_tweet]
      )
    end
  end

  describe "#media_for_last_minutes" do
    it "returns media URLs of in-range tweet" do
      ::Twitter::REST::Client.any_instance.expects(:user_timeline).returns(tweets)
      media_tweet.stubs(:media).returns([media])
      instance.media_for_last_minutes(handle: "@fanolug", minutes: 30).must_equal(
        ["https://media.example.com"]
      )
    end
  end
end
