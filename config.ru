require 'dotenv'
require './lib/fortuna_luca/telegram/webhook_server'

Dotenv.load
run FortunaLuca::Telegram::WebhookServer
