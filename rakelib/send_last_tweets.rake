require_relative '../lib/fortuna_luca/telegram/twitter'
FortunaLuca::Telegram::Twitter.new.send_last_tweets(minutes: 60)