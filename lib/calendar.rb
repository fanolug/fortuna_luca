require 'dotenv'
require 'telegram/bot'
require 'simple-rss'
require 'open-uri'

class Calendar
  attr_reader :telegram_client, :logger

  def initialize
    Dotenv.load
    @logger = Logger.new('log/production.log')
    @telegram_client = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])
  end

  def notify
    rss = SimpleRSS.parse open(ENV['CALENDAR_FEED'])
    timefeed = rss.items.first.pubDate.strftime("%d-%m-%Y %H")
    current_hour = Time.now.strftime("%d-%m-%Y %H")

    if timefeed == current_hour
      telegram_client.api.send_message(chat_id: ENV['TELEGRAM_CHAT_ID'], text: rss.items.first.title)
      logger.info "Calendar#notify run with work"
    else
      logger.info "Calendar#notify run"
    end
  end

end
