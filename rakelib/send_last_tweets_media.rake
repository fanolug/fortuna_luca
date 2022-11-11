require_relative '../lib/fortuna_luca/telegram/twitter'

task :send_last_tweets_media do
  FortunaLuca::Telegram::Twitter.new.send_last_tweets_media(minutes: 60)
end
