# coding: utf-8
require 'fileutils'
require 'logger'
require 'taifu/app'
require 'taifu/version'

module Taifu
  def hit
    url = ARGV.first
    if url.nil?
      raise ArgumentError.new 'You need to specify URL. Try "taifu http://www.youtube.com/watch?v=I1X6MrBfjrk"'
    end

    taifu = App.new
    wav_path = taifu.save_as_wav_with(url)
    taifu.add_track(wav_path)
  end
  module_function :hit
end
