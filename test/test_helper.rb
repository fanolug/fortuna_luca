require "minitest/autorun"
require "mocha/minitest"
require "minitest/reporters"
require "rack/test"
require "webmock/minitest"

ENV["RACK_ENV"] = "test"
ENV["SECRET_WEBHOOK_PATH"] = "/the-secret-path"
ENV["TELEGRAM_BOT_NAME"] = "@fortuna_luca"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
