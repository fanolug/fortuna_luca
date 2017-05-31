require 'twitter'

module TwitterClient
  def tweet!(message, text)

    sender = message.from
    text = "#{text} [#{sender.username}]"

    begin
      tweet = twitter_client.update(text)
      tweet.url.to_s
    rescue Twitter::Error => exception
      logger.error "#{exception.message} (#tweet!)"
      exception.message
    end
  end

  private

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_TOKEN']
      config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end
  end
end
