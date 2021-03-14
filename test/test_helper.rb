require "minitest/autorun"
require "mocha/minitest"
require "minitest/reporters"
require "rack/test"
require "webmock/minitest"
require_relative "../config/i18n"

ENV["RACK_ENV"] = "test"
ENV["SECRET_WEBHOOK_PATH"] = "/the-secret-path"
ENV["SECRET_YT_WEBHOOK_PATH"] = "/the-yt-secret-path"
ENV["TELEGRAM_BOT_NAME"] = "@fortuna_luca"
ENV["YOUTUBE__abcdefg"] = "-12345"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
