# frozen_string_literal: true

require "dotenv/load"
require 'sinatra/base'
require 'json'
require 'telegram/bot'
require_relative 'responder'

module FortunaLuca
  module Telegram
    class WebhookServer < Sinatra::Base
      enable :logging

      get '/' do
        'Fortuna Luca by FortunaeLUG'
      end

      # Handle webhooks coming from Telegram
      post ENV['SECRET_WEBHOOK_PATH'] do
        msg = message(request)
        Responder.new(msg).call

        200
      end

      private

      def message(request)
        data = parsed_body(request)
        message = ::Telegram::Bot::Types::Message.new(data['message'])
        logger.info message.inspect
        message
      end

      def parsed_body(request)
        JSON.parse(request.body.read)
      end
    end
  end
end
