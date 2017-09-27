require 'dotenv'
require 'twitter-text'
require 'time'
require_relative 'logging'
require_relative 'xkcd'
require_relative 'telegram_client'
require_relative 'twitter_client'
require_relative 'twitter_reader'
require_relative 'googlecalendar_client'
require_relative 'ai/responder'

class Bot
  include Logging
  include TelegramClient
  include TwitterClient
  include GoogleClient

  def run!
    Dotenv.load
    name = 'Fortuna Luca telegram bot'
    Process.setproctitle(name)
    Process.daemon(true, true) unless ENV["DEVELOPMENT"]
    logger.info "Running as '#{name}', pid #{Process.pid}"
    run_telegram_loop
  end

  def send_last_tweets(minutes: 60)
    followed_twitter_handlers.each do |handler|
      TwitterReader.new(handler).tweets_for_last_minutes(minutes).each do |tweet|
        send_message(ENV['TELEGRAM_CHAT_ID'], tweet.text)
      end
    end
  end

  def send_last_tweets_media(minutes: 60)
    followed_twitter_handlers.each do |handler|
      TwitterReader.new(handler).media_for_last_minutes(minutes).each do |media_url|
        send_message(ENV['TELEGRAM_CHAT_ID'], media_url)
      end
    end
  end

  private

  def handle_message(message)
    # clean up text
    text = message.text.to_s.tr("\n", ' ').squeeze(' ').strip

    case text
    # display an help message
    when '', /^\/help/i # /help
      send_help(message)
    # post the link on twitter and on the mailing list
    when /^\/ilinkdellasettimana (.+)/i # /ilinkdellasettimana
      return unless validate_message(message, text)
      result = tweet!(message.from.username, $1)
      send_message(message.from.id, result)
    # display a XKCD comic
    when /^\/(xkcd|comics)/i # /xkcd or /comics
      send_message(message.chat.id, Xkcd.new.random_image)
    # get the first web search result link
    when /^\/google (.+)/i # /google
      send_message(message.chat.id, WebSearcher.new($1).first_link)
    when /^\/meteops/i
      send_message(message.chat.id, "http://trottomv.suroot.com/meteo#{Time.now.strftime("%Y%m%d")}.png")
    # default: try AI to generate some response
    else
      text = text.sub(/\A\/\S* /, "") # remove /command part
      send_message(message.chat.id, AI::Responder.new(text).call)
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

  def followed_twitter_handlers
    @followed_twitter_handlers ||= ENV['TWITTER_HANDLERS'].split(',').map(&:strip)
  end
end
