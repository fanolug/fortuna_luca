require 'dotenv'
require 'twitter-text'
require_relative 'xkcd'
require_relative 'telegram_client'
require_relative 'twitter_client'
require_relative 'twitter_reader'
require_relative 'googlecalendar_client'
require_relative 'apiai_client'
require_relative 'forecast'
require_relative 'web_searcher'

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
    when '', /^\/help/i
      send_help(message)
    when /^\/ilinkdellasettimana (.+)/i
      return unless validate_message(message, text)
      result = tweet!(message.from.username, $1)
      send_message(message.from.id, result)
    when /^\/(xkcd|comics)/i
      send_message(message.chat.id, Xkcd.new.random_image)
    when /^\/google (.+)/i
      send_message(message.chat.id, WebSearcher.new($1).first_link)
    when /^\/meteops/i
      send_message(message.chat.id, "http://trottomv.suroot.com/meteo#{Time.now.strftime("%Y%m%d")}.png")
    when /^\/luca (.+)/i
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

  def handle_ai_response(response)
    # direct speech response
    speech = response.dig(:result, :fulfillment, :speech)
    return speech if speech && speech != ""

    # no speech response
    case response.dig(:result, :action)
    when "weather" then handle_weather_response(response)
    when "help" then handle_weather_response(response)
    else
      # TODO nothing?
    end
  end

  def handle_weather_response(response)
    city = parse_weather_city(response)
    time = parse_weather_time(response)
    forecast = summary_forecast_for(city, time)
    return if !forecast

    "A #{city} #{forecast.downcase}"
  end

  def fallback_weather_city
    "Fano"
  end

  def fallback_weather_time
    (Time.now + 12 * 3600).to_s
  end

  def parse_weather_time(response)
    time = response.dig(:result, :parameters, :"date-time")
    begin
      Date.parse(time.to_s).to_time
    rescue ArgumentError => e
      logger.debug("Invalid time '#{time}'?: #{e.message}")
      fallback_weather_time
    end
  end

  def parse_weather_city(response)
    address = response.dig(:result, :parameters, :address)
    city = address.respond_to?(:dig) ? address.dig(:city) : address
    city = fallback_weather_city if !city || city == ""
    city
  end
end
