require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/telegram/youtube_responder"

describe FortunaLuca::Telegram::YoutubeResponder do
  let(:instance) { FortunaLuca::Telegram::YoutubeResponder.new(data) }

  describe "#call" do
    describe "with valid feed data" do
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
              <yt:channelId>CHANNEL_ID</yt:channelId>
              <title>Video title</title>
              <link rel="alternate" href="http://www.youtube.com/watch?v=VIDEO_ID"/>
              <author>
               <name>Channel title</name>
               <uri>http://www.youtube.com/channel/CHANNEL_ID</uri>
              </author>
              <published>2015-03-06T21:40:57+00:00</published>
              <updated>2015-03-09T19:05:24.552394234+00:00</updated>
            </entry>
          </feed>
        DATA
      end

      it "returns the first entry URL" do
        instance.call.must_equal("http://www.youtube.com/watch?v=VIDEO_ID")
      end
    end
  end

  describe "with invalid feed data" do
    let(:data) { "not a feed" }

    it "returns the first entry URL" do
      instance.call.must_equal(nil)
    end
  end
end
