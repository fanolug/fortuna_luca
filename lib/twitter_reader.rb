require 'dotenv'
require_relative 'twitter_client'

class TwitterReader
  include TwitterClient

  attr_reader :twitter_handle

  def initialize(twitter_handle)
    Dotenv.load
    @twitter_handle = twitter_handle
  end

  def tweets(params = default_twitter_params)
    twitter_client.user_timeline(twitter_handle, params)
  end

  def tweets_for_last_minutes(minutes)
    tweets.take_while do |tweet|
      Time.now - tweet.created_at <= minutes * 60
    end
  end

  def media_for_last_minutes(minutes)
    tweets_for_last_minutes(minutes).map do |tweet|
      tweet.media&.first&.media_url&.to_s
    end.compact
  end

  private

  def default_twitter_params
    { count: 3, trim_user: true, exclude_replies: true, include_rts: true }
  end
end
