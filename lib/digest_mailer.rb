require 'dotenv'
require 'mail'
require 'twitter-text'
require_relative 'twitter_client'

class DigestMailer
  include Twitter::Rewriter
  include TwitterClient

  def initialize
    Dotenv.load
  end

  def deliver!
    mail = Mail.new
    mail.delivery_method(:smtp, smtp_config)
    mail.from ='Fortuna Luca <fortuna.luca@fanolug.org>'
    mail.to = 'fanolug@googlegroups.com'
    mail.subject "[i link della settimana] #{Date.today.strftime("%d/%m")}"
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
      # rewrite short urls as full urls
      rewrite_entities(tweet.text.dup, tweet.urls) do |entity, _|
        entity.expanded_url
      end
    end.join("\n\n")
  end

  def tweets_from_last_week
    params = { count: 100, exclude_replies: true, include_rts: false }
    tweets = twitter_client.user_timeline('@fanolug', params)

    tweets.take_while do |tweet|
      tweet.created_at.to_datetime >= DateTime.now - 7 # 1 week ago
    end.find_all do |tweet|
      tweet.text =~ /.+\[.+\]$/ # match common pattern
    end
  end
end
