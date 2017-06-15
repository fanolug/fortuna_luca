require 'dotenv'
require 'twitter-text'
require_relative 'xkcd'
require_relative 'telegram_client'
require_relative 'twitter_client'
require_relative 'twitter_reader'
require_relative 'googlecalendar_client'
require_relative 'apiai_client'

class Bot
  include TelegramClient
  include TwitterClient
  include GoogleClient
  include ApiaiClient

  def run!
    Dotenv.load
    name = 'Fortuna Luca telegram bot'
    Process.setproctitle(name)
    Process.daemon(true, true)
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

  def send_next_event
    # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = GoogleCalendarAPI.new.authorize
    # Fetch the next events for the user
    calendar_id = "#{ENV['IDCAL']}"
    response = service.list_events(calendar_id,
                                   max_results: 1,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: Time.now.iso8601)

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      case start.strftime('%Y%m%d%H%M')
      when Time.now.strftime('%Y%m%d%H%M')
        send_message(ENV['CHAT_ID'], "#{event.summary}")
      end
    end
  end

  private

  def handle_message(message)
    # clean up text
    text = message.text.to_s.gsub("\n", ' ').squeeze(' ').strip

    case text
    when '', /^\/help/
      send_help(message)
    when /^\/ilinkdellasettimana (.+)/
      return unless validate_message(message, text)
      result = tweet!(message, $1)
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
      errors << "Error: #{result.to_s.gsub('_', ' ').capitalize}"
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
    @logger ||= Logger.new('log/production.log')
  end
end
