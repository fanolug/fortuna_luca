require 'dotenv'
require 'telegram/bot'
require 'simple-rss'
require 'open-uri'

class Comics
  attr_reader :telegram_client, :logger

  def initialize
    Dotenv.load
    @logger = Logger.new('log/production.log')
    @telegram_client = Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])
  end

  def notifyxkcd
    rss = SimpleRSS.parse open('http://xkcd.com/rss.xml')
    timefeed = rss.items.first.pubDate.strftime("%d-%m-%Y")
    current_day = Time.now.strftime("%d-%m-%Y")

    if timefeed == current_day
      telegram_client.api.send_message(chat_id: ENV['TELEGRAM_CHAT_ID'], text: rss.items.first.title)
      logger.info "Comics#notifyxkcd run with work"
    else
      logger.info "Comics#notifyxkcd run"
    end
  end

  def notifytous
    rss = SimpleRSS.parse open('http://turnoff.us/feed.xml')
    timefeed = rss.items.first.pubDate.strftime("%d-%m-%Y %H")
    prev_hour = (Time.now - 3600).strftime("%d-%m-%Y %H")

    if timefeed == prev_hour
      telegram_client.api.send_message(chat_id: ENV['TELEGRAM_CHAT_ID'], text: rss.items.first.title)
      logger.info "Comics#notifytous run with work"
    else
      logger.info "Comics#notifytous run"
    end
  end

end
