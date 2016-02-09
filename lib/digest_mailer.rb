require 'dotenv'
require 'mail'
require 'twitter'
require 'twitter-text'

class DigestMailer
  include Twitter::Rewriter

  attr_reader :twitter_client

  def initialize
    Dotenv.load
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_TOKEN']
      config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end
  end

  def deliver!
    mail = Mail.new
    mail.delivery_method(:smtp, smtp_config)
    mail.from ='Fortuna Luca <fortuna.luca@fanolug.org>'
    mail.to = 'a.lepore@freegoweb.it'
    mail.subject '[i link della settimana]'
    mail.body = content
    mail.deliver! if content
  end

  private

  def smtp_config
    {
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      address: ENV['SMTP_HOST'],
      port: ENV['SMTP_PORT'],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end

  def content
    tweets = tweets_from_last_week
    return if tweets.none?

    tweets.reverse.map do |tweet|
      rewrite_entities(tweet.text.dup, tweet.urls) do |entity, _|
        entity.expanded_url
      end
    end.join("\n\n").gsub(' #ilds ', ' ') # temporary
  end

  def tweets_from_last_week
    params = { count: 100, exclude_replies: true, include_rts: false }
    tweets = twitter_client.user_timeline('@fanolug', params)

    tweets.take_while do |tweet|
      tweet.created_at.to_datetime >= DateTime.now - 7 # 1 week ago
    end.find_all do |tweet|
      tweet.text =~ /.+\[.+\]$/
    end
  end
end
