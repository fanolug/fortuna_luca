require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/youtube_responder"

describe FortunaLuca::Telegram::YoutubeResponder do
  let(:instance) { FortunaLuca::Telegram::YoutubeResponder.new(data) }

  before do
    Redis.stubs(:new).returns(MockRedis.new)
  end

  describe "#call" do
    describe "with valid feed data" do
      let(:published) { "2015-03-06T21:40:57+00:00" }
      let(:updated) { published }
      let(:data) do
        <<~DATA
          <feed xmlns:yt="http://www.youtube.com/xml/schemas/2015"
                   xmlns="http://www.w3.org/2005/Atom">
            <link rel="hub" href="https://pubsubhubbub.appspot.com"/>
            <link rel="self" href="https://www.youtube.com/xml/feeds/videos.xml?channel_id=CHANNEL_ID"/>
            <title>YouTube video feed</title>
            <updated>2015-04-01T19:05:24.552394234+00:00</updated>
            <entry>
              <id>yt:video:VIDEO_ID</id>
              <yt:videoId>VIDEO_ID</yt:videoId>
              <yt:channelId>abcdefg</yt:channelId>
              <title>Video title</title>
              <link rel="alternate" href="http://www.youtube.com/watch?v=VIDEO_ID"/>
              <author>
               <name>Channel title</name>
               <uri>http://www.youtube.com/channel/CHANNEL_ID</uri>
              </author>
              <published>#{published}</published>
              <updated>#{updated}</updated>
            </entry>
          </feed>
        DATA
      end

      it "sends message with the first entry URL" do
        Telegram::Bot::Api.any_instance.expects(:send_message).with(
          { chat_id: "-12345", text: "http://www.youtube.com/watch?v=VIDEO_ID" }
        )
        instance.call
      end

      describe "when entry is already processed" do
        before do
          instance.expects(:process_id!).returns(false)
        end

        it "does not send a message" do
          Telegram::Bot::Api.any_instance.expects(:send_message).never
          instance.call
        end
      end
    end
  end

  describe "with invalid feed data" do
    let(:data) { "not a feed" }

    it "does not send a message" do
      Telegram::Bot::Api.any_instance.expects(:send_message).never
      instance.call
    end
  end
end
