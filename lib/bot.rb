require 'dotenv'
require 'telegram/bot'
require 'twitter'
require 'xkcd'

class Bot
  attr_reader :name, :telegram_client, :twitter_client, :logger

  def initialize
    Dotenv.load
    @name = 'Fortuna Luca telegram bot'
    @logger = Logger.new('log/production.log')

    telegram_client_init
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

    loop do
      begin
        telegram_client.run do |bot|
          bot.listen do |message|
            text = message.text.to_s.gsub("\n", ' ').squeeze(' ').strip # clean up

            case text
            when '', /^\/help/
              send_help(message)
            when /^\/ilinkdellasettimana (.+)/
              tweet!(message, $1)
            when /^\/(xkcd|comics)/
              respond(message.chat.id, XKCD.img)
            when /^\/meteops/
              respond(message.chat.id, "http://trottomv.dtdns.net/meteo#{Time.now.strftime("%Y%m%d")}.png")
            end
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => exception
        logger.error "#{exception.message} (#run)"
        raise if exception.error_code == '409'
        telegram_client_init
      end
    end
  end

  private

  def respond(chat_id, text)
    begin
      telegram_client.api.send_message(chat_id: chat_id, text: text)
    rescue Telegram::Bot::Exceptions::ResponseError => exception
      logger.error "#{exception.message} (#respond chat_id: #{chat_id}, text: #{text})"
    end
  end

  def send_help(message)
    respond(message.from.id, "Usage:\n/ilinkdellasettimana <descrizione, link eccetera> - Posta su Twitter")
  end

  def tweet!(message, text)
    return unless validate(message, text)

    sender = message.from
    text = "#{text} [#{sender.username}]"
    tweet = twitter_client.update(text)
    respond(sender.id, tweet.url.to_s)
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

  def telegram_client_init
    @telegram_client = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])
  end
end
