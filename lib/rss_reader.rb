require 'simple-rss'
require 'open-uri'
require 'twitter-text/extractor'
require 'twitter-text/regex'

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
    end.each do |item|
      item[:chat_preview] = chat_preview_for(item)
    end
  end

  private

  def chat_preview_for(item)
    if item.link =~ /turnoff.us/
      item.link.sub('/geek/', '/image/en/') + '.png'
    elsif item.link =~ /commitstrip.com/
      link = Twitter::Extractor.extract_urls(item.content_encoded).first
      "#{item.title} #{link}" if link
    elsif feed.title =~ /flucacal/
      item.title
    else
      item.link
    end
  end
end
