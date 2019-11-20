require "minitest/autorun"
require "mocha/mini_test"
require "minitest/reporters"
require "rack/test"

ENV["RACK_ENV"] = "test"
ENV["SECRET_WEBHOOK_PATH"] = "/the-secret-path"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
