require "dotenv"
require_relative "../lib/fortuna_luca/telegram/client"
require_relative "../lib/fortuna_luca/twitter/client"

desc "Sends tweets media to the Telegram channel"
task :send_last_tweets_media do
  include FortunaLuca::Telegram::Client
  include FortunaLuca::Twitter::Client

  Dotenv.load

  followed_twitter_handlers.each do |handle|
    media_for_last_minutes(handle: handle, minutes: 60).each do |media_url|
      send_telegram_message(ENV["TELEGRAM_CHAT_ID"], media_url)
    end
  end
end
