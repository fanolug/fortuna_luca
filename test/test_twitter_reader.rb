require_relative "test_helper"
require_relative "../lib/twitter_reader"

describe TwitterReader do
  before do
    @twitter_reader = TwitterReader.new("@fanolug")
  end

  describe "#tweets" do
    it "sends the api request" do
      Twitter::REST::Client.any_instance.expects(:user_timeline).with(
        "@fanolug", {}
      )
      @twitter_reader.tweets({})
    end

    it "uses default params" do
      Twitter::REST::Client.any_instance.expects(:user_timeline).with(
        "@fanolug",
        { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
      )
      @twitter_reader.tweets
    end
  end
end
