# coding: utf-8

require 'bundler'
require 'fakefs/spec_helpers'
require 'coveralls'

Bundler.setup(:default, :development)
Coveralls.wear!

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  #config.formatter = :documentation
  config.include FakeFS::SpecHelpers, fakefs: true
end
