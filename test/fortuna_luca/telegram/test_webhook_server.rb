require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/webhook_server"

include Rack::Test::Methods

describe FortunaLuca::Telegram::WebhookServer do
  let(:app) { FortunaLuca::Telegram::WebhookServer }

  describe "GET /" do
    it "returns a static text" do
      get "/"
      last_response.ok?.must_equal(true)
      last_response.body.must_equal("Fortuna Luca by FortunaeLUG")
    end
  end

  describe "POST /the-secret-path-set-on-ENV" do
    it "calls the responder and returns 200" do
      FortunaLuca::Telegram::Responder.any_instance.expects(:call).returns("the response")
      post "/the-secret-path", "{}"
      last_response.ok?.must_equal(true)
      last_response.body.must_equal("")
    end
  end

  describe "POST /the-yt-secret-path-set-on-ENV" do
    it "calls the responder and returns 200" do
      FortunaLuca::Telegram::YoutubeResponder.any_instance.expects(:call).returns("the response")
      post "/the-yt-secret-path", "{}"
      last_response.ok?.must_equal(true)
      last_response.body.must_equal("")
    end
  end

  describe "POST /the-strava-secret-path-set-on-ENV" do
    it "calls the responder and returns 200" do
      FortunaLuca::Telegram::StravaResponder.any_instance.expects(:call).returns("the response")
      post "/the-strava-secret-path", "{}"
      last_response.ok?.must_equal(true)
      last_response.body.must_equal("")
    end
  end
end
