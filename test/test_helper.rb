require "minitest/autorun"
require "mocha/minitest"
require "minitest/reporters"
require "rack/test"
require "webmock/minitest"
require "mock_redis"
require_relative "../lib/fortuna_luca"

ENV["RACK_ENV"] = "test"
ENV["STRAVA_CHAT_ID"] = "12345"
ENV["TELEGRAM_BOT_COMMAND"] = "/lucas"
ENV["YOUTUBE__abcdefg"] = '["-12345"]'
ENV["WIKIPEDIA_ON_THIS_DAY_CHAT_IDS"] = '["12345"]'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
