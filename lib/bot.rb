require 'dotenv'
require 'twitter-text'
require 'time'
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
    # /help
    # display an help message
    when '', /^\/help/i
      send_help(message)
    # /ilinkdellasettimana
    # post the link on twitter and on the mailing list
    when /^\/ilinkdellasettimana (.+)/i
      return unless validate_message(message, text)
      result = tweet!(message.from.username, $1)
      send_message(message.from.id, result)
    # /xkcd or /comics
    # display a XKCD comic
    when /^\/(xkcd|comics)/i
      send_message(message.chat.id, Xkcd.new.random_image)
    # /google
    # get the first web search result link
    when /^\/google (.+)/i
      send_message(message.chat.id, WebSearcher.new($1).first_link)
    when /^\/meteops/i
      send_message(message.chat.id, "http://trottomv.suroot.com/meteo#{Time.now.strftime("%Y%m%d")}.png")
    # /luca
    # use AI to generate some response
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
    # when a direct speech response is available
    speech = response.dig(:result, :fulfillment, :speech)
    return speech if speech && speech != ""

    # when no speech response is available
    case response.dig(:result, :action)
    when "weather" then handle_weather_ai_action(response)
    when "web_query" then handle_web_query_ai_action(response)
    else
      # TODO nothing?
    end
  end

  def handle_weather_ai_action(response)
    city = parse_weather_city(response)
    time = parse_weather_time(response)
    forecast = daily_forecast_for(city, time)
    return if !forecast

    context = response.dig(:result, :contexts).find do |c|
      c[:name] == "weather"
    end
    time_in_words = if context
      context.dig(:parameters, :"date-time.original")
    end

    [
      time_in_words&.capitalize,
      "a #{city}",
      forecast.downcase
    ].compact.join(" ")
  end

  def fallback_weather_city
    "Fano"
  end

  def parse_weather_time(response)
    date_string = response.dig(:result, :parameters, :"date-time")
    now = Time.now

    begin
      date = Time.parse(date_string.to_s)
      date < now ? now : date
    rescue ArgumentError => e
      logger.debug("Invalid date string '#{date}': #{e.message}")
      now
    end
  end

  def parse_weather_city(response)
    address = response.dig(:result, :parameters, :address)
    city = address.respond_to?(:dig) ? address.dig(:city) : address
    city = fallback_weather_city if !city || city == ""
    city
  end

  def handle_web_query_ai_action(response)
    query = response.dig(:result, :parameters, :query)
    return if query.to_s == ""

    WebSearcher.new(query).first_link
  end
end
