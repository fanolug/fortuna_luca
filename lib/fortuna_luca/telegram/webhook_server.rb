# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'telegram/bot'
require_relative 'bot'

module FortunaLuca
  module Telegram
    class TelegramWebhookServer < Sinatra::Base
      enable :logging

      get '/' do
        'Fortuna Luca by FortunaeLUG'
      end

      # Handle webhooks coming from Telegram
      post ENV['SECRET_WEBHOOK_PATH'] do
        200
      end
    end
  end
end
