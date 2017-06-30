require 'dotenv'
require 'twitter-text'
require_relative 'xkcd'
require_relative 'telegram_client'
require_relative 'twitter_client'
require_relative 'twitter_reader'
require_relative 'googlecalendar_client'
require_relative 'apiai_client'
require_relative 'forecast'

class Bot
  include TelegramClient
  include TwitterClient
  include GoogleClient
  include ApiaiClient
  include Forecast

  def run!
    Dotenv.load
    name = 'Fortuna Luca telegram bot'
    Process.setproctitle(name)
    Process.daemon(true, true) unless ENV["DEVELOPMENT"]
    logger.info "Running as '#{name}', pid #{Process.pid}"
    run_telegram_loop
  end

  def send_last_tweets(minutes: 60)
    twitter_handlers.each do |handler|
      TwitterReader.new(handler).tweets_for_last_minutes(minutes).each do |tweet|
        send_message(ENV['TELEGRAM_CHAT_ID'], tweet.text)
      end
    end
  end

  private

  def handle_message(message)
    # clean up text
    text = message.text.to_s.tr("\n", ' ').squeeze(' ').strip

    case text
    when '', /^\/help/
      send_help(message)
    when /^\/ilinkdellasettimana (.+)/
      return unless validate_message(message, text)
      result = tweet!(message.from.username, $1)
      send_message(message.from.id, result)
    when /^\/(xkcd|comics)/
      send_message(message.chat.id, Xkcd.new.random_image)
    when /^\/meteops/
      send_message(message.chat.id, "http://trottomv.suroot.com/meteo#{Time.now.strftime("%Y%m%d")}.png")
    when /^\/luca (.+)/
      send_message(message.chat.id, ai_response_to($1))
    end
  end

  def send_help(message)
    send_message(message.from.id, "Usage:\n/ilinkdellasettimana <descrizione, link eccetera> - Posta su Twitter")
  end

  def validate_message(message, text)
    errors = []

    if result = Twitter::Validation.tweet_invalid?(text)
      errors << "Error: #{result.to_s.tr('_', ' ').capitalize}"
    end

    if message.from.username.to_s.empty?
      errors << "Error: You have to set up your Telegram username first"
    end

    if message.chat.id.to_s != ENV['TELEGRAM_CHAT_ID']
      errors << "Error: Commands from this chat are not allowed"
    end

    if text.to_s.size < 10
      errors << "Error: Message is too short"
    end

    if errors.any?
      error_messages = errors.join("\n")
      logger.warn error_messages
      telegram_client.api.send_message(chat_id: message.from.id, text: error_messages)
    end

    errors.none?
  end

  def twitter_handlers
    @twitter_handlers ||= ENV['TWITTER_HANDLERS'].split(',').map(&:strip)
  end

  def logger
    return @logger if @logger

    output = ENV["DEVELOPMENT"] ? STDOUT : "log/production.log"
    @logger = Logger.new(output)
  end
end
