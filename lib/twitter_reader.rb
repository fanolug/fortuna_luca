require 'dotenv'
require 'twitter'

class TwitterReader
  attr_reader :twitter_handle

  def initialize(twitter_handle)
    Dotenv.load
    @twitter_handle = twitter_handle
  end

  def tweets
    params = { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
    twitter_client.user_timeline(twitter_handle, params)
  end

  def tweets_for_last_minutes(minutes)
    tweets.take_while do |tweet|
      Time.now - tweet.created_at <= minutes * 60
    end
  end

  private

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_TOKEN']
      config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end
  end

end
