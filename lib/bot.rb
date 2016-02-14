require 'dotenv'
require 'telegram/bot'
require 'twitter'

class Bot
  attr_reader :name, :telegram_client, :twitter_client

  def initialize
    Dotenv.load
    @name = 'Fortuna Luca telegram bot'

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
    puts "Running as '#{name}', pid #{Process.pid}"

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
          puts "ERROR: #{exception.message}"
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
    sender = message.from
    if sender.username.empty?
      telegram_client.api.send_message(chat_id: sender.id,
                                       text: "Error: You have to set up your Telegram username first.")
    else
      puts "wrong chat: #{message.chat.id}" and return if message.chat.id != ENV['TELEGRAM_CHAT_ID']
      puts "too short" and return if text.size < 10

      text = "#{text} [#{sender.username}]"
      tweet = twitter_client.update(text)
      telegram_client.api.send_message(chat_id: sender.id, text: tweet.url.to_s)
    end
  end
end
