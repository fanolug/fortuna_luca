require 'dotenv'
require 'telegram/bot'
require_relative 'xkcd'
require_relative 'twitter_client'
require_relative 'twitter_reader'
require_relative 'googlecalendar_client'

class Bot
  include TwitterClient
  include GoogleClient

  def run!
    Dotenv.load
    name = 'Fortuna Luca telegram bot'
    Process.setproctitle(name)
    Process.daemon(true, true)
    logger.info "Running as '#{name}', pid #{Process.pid}"
    run_telegram_loop
  end

  def send_message(chat_id, text)
    begin
      telegram_client.api.send_message(chat_id: chat_id, text: text)
    rescue Telegram::Bot::Exceptions::ResponseError => exception
      logger.error "#{exception.message} (#send_message chat_id: #{chat_id}, text: #{text})"
    end
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

  def run_telegram_loop
    loop do
      begin
        telegram_client.run do |bot|
          bot.listen do |message|
            handle_message(message)
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => exception
        logger.error "#{exception.message} (#run_telegram_loop)"
        handle_exception(exception)
      end
    end
  end

  def handle_message(message)
    # clean up text
    text = message.text.to_s.gsub("\n", ' ').squeeze(' ').strip

    case text
    when '', /^\/help/
      send_help(message)
    when /^\/ilinkdellasettimana (.+)/
      tweet!(message, $1)
    when /^\/(xkcd|comics)/
      send_message(message.chat.id, Xkcd.new.random_image)
    when /^\/meteops/
      send_message(message.chat.id, "http://trottomv.suroot.com/meteo#{Time.now.strftime("%Y%m%d")}.png")
    end
  end

  def send_help(message)
    send_message(message.from.id, "Usage:\n/ilinkdellasettimana <descrizione, link eccetera> - Posta su Twitter")
  end

  def tweet!(message, text)
    return unless validate(message, text)

    sender = message.from
    text = "#{text} [#{sender.username}]"
    tweet = twitter_client.update(text)
    send_message(sender.id, tweet.url.to_s)
  end

  def validate(message, text)
    errors = []
    if message.from.username.to_s.empty?
      errors << "Error: You have to set up your Telegram username first"
    end

    if message.chat.id.to_s != ENV['TELEGRAM_CHAT_ID']
      errors << "Error: Commands from this chat are not allowed"
    end

    if text.to_s.size < 10
      errors << "Error: Message is too short"
    end
    
    if text.size.gsub(/(?:f|ht)tps?:\/[^\s]+/, '') > 117
      errors << "Error: Message is too long"
    end

    if errors.any?
      error_messages = errors.join("\n")
      logger.warn error_messages
      telegram_client.api.send_message(chat_id: message.from.id, text: error_messages)
    end

    errors.none?
  end

  def telegram_client(options = {})
    @telegram_client ||= Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'],
                                                   options.merge(logger: logger))
  end

  def twitter_handlers
    @twitter_handlers ||= ENV['TWITTER_HANDLERS'].split(',').map(&:strip)
  end

  def logger
    @logger ||= Logger.new('log/production.log')
  end

  def handle_exception(exception)
    case exception.error_code
    when 409
      logger.info "Exiting."
      Process.exit
    end

    sleep 10
    @telegram_client = nil # reconnect
  end
end
