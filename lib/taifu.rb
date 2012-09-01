# coding: utf-8
require 'fileutils'
require 'appscript'

require "taifu/app"
require "taifu/version"

module Taifu
  def hit
    url = ARGV.first
    if url.nil?
      raise ArgumentError.new 'You need to specify URL. Try "taifu http://www.youtube.com/watch?v=I1X6MrBfjrk"'
    end
    App.new(url)
  end
  module_function :hit
end
