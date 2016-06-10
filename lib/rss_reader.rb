require 'simple-rss'
require 'open-uri'

class RssReader
  attr_reader :feed

  def initialize(url)
    @feed = SimpleRSS.parse open(url)
  end

  def items
    feed.items
  end

  def items_for_last_minutes(minutes)
    items.take_while do |item|
      Time.now.utc - item.pubDate.utc <= minutes * 60
    end
  end

end
