require 'dotenv'
require 'telegram/bot'
require 'twitter'

class Bot
  attr_reader :name, :telegram_client, :twitter_client, :logger

  def initialize
    Dotenv.load
    @name = 'Fortuna Luca telegram bot'
    @logger = Logger.new('log/production.log')

    @telegram_client = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_TOKEN']
      config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end
  end

  def run!
    Process.setproctitle(name)
    Process.daemon(true, true)
    logger.info "Running as '#{name}', pid #{Process.pid}"

    telegram_client.run do |bot|
      bot.listen do |message|
        begin
          text = message.text.gsub("\n", ' ').squeeze(' ').strip # clean up
          case text
          when /^\/help/
            send_help(message)
          when /^\/ilinkdellasettimana (.+)/
            tweet!(message, $1)
          end
        rescue => exception
          logger.error exception.message
        end
      end
    end
  end

  private

  def send_help(message)
    telegram_client.api.send_message(chat_id: message.from.id,
                                     text: "Usage:\n/ilinkdellasettimana <descrizione, link eccetera> - Posta su Twitter")
  end

  def tweet!(message, text)
    return unless validate(message, text)

    sender = message.from
    text = "#{text} [#{sender.username}]"
    tweet = twitter_client.update(text)
    telegram_client.api.send_message(chat_id: sender.id, text: tweet.url.to_s)
  end

  def validate(message, text)
    errors = []
    if message.from.username.empty?
      errors << "Error: You have to set up your Telegram username first"
    end

    if message.chat.id.to_s != ENV['TELEGRAM_CHAT_ID']
      errors << "Error: Commands from this chat are not allowed"
    end

    if text.size < 10
      errors << "Error: Message is too short"
    end

    if errors.any?
      error_messages = errors.join("\n")
      logger.warn error_messages
      telegram_client.api.send_message(chat_id: message.from.id, text: error_messages)
    end

    errors.none?
  end
end
