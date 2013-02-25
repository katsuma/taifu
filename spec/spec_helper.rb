# coding: utf-8

require 'bundler'
Bundler.setup(:default, :development)

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation
end
