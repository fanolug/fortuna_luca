require "logger"
require "minitest/autorun"
require "mocha/minitest"
require "minitest/reporters"
require "pry"
require "rack/test"
require 'tzinfo'
require "webmock/minitest"
require_relative "../config/i18n"

ENV["RACK_ENV"] = "test"
ENV["SECRET_WEBHOOK_PATH"] = "/the-secret-path"
ENV["TELEGRAM_BOT_NAME"] = "@fortuna_luca"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

timezone_name = 'EU/Rome'