require "dotenv"
require_relative "test_helper"
require_relative "../lib/facebook_reader"

describe FacebookReader do
  before do
    Dotenv.load
    @facebook_reader = FacebookReader.new("fanolug")
  end

  describe "#koala" do
    it "sends the api request" do
      Koala::Facebook::API.any_instance
    end

    it "test posts" do
      Koala::Facebook::API.any_instance.expects(:get_object).with(
        'fanolug/posts?fields=full_picture,created_time,message&limit=5')
      @facebook_reader.posts
    end
  end

end
