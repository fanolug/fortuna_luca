# frozen_string_literal: true

require 'dotenv/load'
require 'sinatra/base'
require 'json'
require 'telegram/bot'
require_relative 'responder'
require_relative 'youtube_responder'

module FortunaLuca
  module Telegram
    class WebhookServer < Sinatra::Base
      enable :logging

      get '/' do
        'Fortuna Luca by FortunaeLUG'
      end

      # Handle webhooks coming from Telegram
      post ENV['SECRET_WEBHOOK_PATH'] do
        Responder.new(telegram_message(request)).call
        200
      end

      # Handle notifications coming from Youtube
      post ENV['SECRET_YT_WEBHOOK_PATH'] do
        YoutubeResponder.new(request.body.read).call
        200
      end

      private

      def telegram_message(request)
        data = JSON.parse(request.body.read)
        logger.info data
        ::Telegram::Bot::Types::Message.new(data['message'])
      end
    end
  end
end
