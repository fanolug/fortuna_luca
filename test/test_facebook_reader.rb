require_relative "test_helper"
require_relative "../lib/facebook_reader"

describe FacebookReader do
  before do
    @facebook_reader = FacebookReader.new("fanolug")
  end

  describe "#posts" do
    it "sends the api request" do
      Koala::Facebook::API.any_instance
    end

    it "test get_object" do
      Koala::Facebook::API.any_instance
      @facebook_reader.posts
    end
  end

end
