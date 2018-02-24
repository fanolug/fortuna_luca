require 'dotenv'
require_relative "test_helper"
require_relative "../lib/facebook_reader"

describe FacebookReader do
  before do
    # @facebook_reader = FacebookReader.new.initialize!
    Dotenv.load
    @graph = Koala::Facebook::API.any_instance.expects(:token).with(
      ENV['FB_APP_TOKEN'], {}
    )
    # @test_users = Koala::Facebook::TestUsers.new(:app_id => id, :secret => "secret")
    # @test_users = Koala::Facebook::TestUsers.new(:app_id => '880327055470286', :app_access_token => 'EAAMgpx1tbs4BACJZBrOYymrZC9sWuPPw88JUOf1ZCicrfyRVAh0wyFfmIRHlJ40NbWzmNWwW087OKYILZCUxbkoCzgbmkCnko5W4EZBylYyS3ZB7qDDvtRvb9XbysJmS6bB3galEmvAzC8Ibqf8EDasTKmynQLDHVZAt8rWDOjScPk30kxf0ZAezMI2LgU89k4sZD' )
  end

  describe "#posts" do
    it "sends the api request" do
      # @graph = Koala::Facebook::TestUsers.new(:app_id => id, :app_access_token => access_token)
      # @facebook_reader.any_instance.expects(:pagename).with(
      #     "fanolug/posts", {}
      #   )
      # @facebook_reader.get_object({})
      # FacebookReader.posts
      # Koala::Facebook::API.any_instance.expects(:pagename).with(
      @graph.get_object.any_instance.expects(:pagename).with(
        "fanolug/posts", {}
      )
      FacebookReader.new.posts["id"]
      # @facebook_reader = @graph
      # @facebook_reader.posts({})
    end

    # it "uses default params" do
    #   Koala::Facebook::API.any_instance.expects(:pagename).with(
    #     "fanolug",
    #     # { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
    #   )
    #   @facebook_reader.posts
    # end
  end

end
