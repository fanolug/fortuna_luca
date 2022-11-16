require_relative '../lib/fortuna_luca/telegram/twitter'

task :send_last_tweets do
  FortunaLuca::Telegram::Twitter.new.send_last_tweets(minutes: 60)
end
