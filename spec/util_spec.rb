# coding: utf-8
require 'spec_helper'
require 'taifu'

describe Taifu::Util do
  let(:util) { Taifu::Util }

  describe '.save_flv_from_url' do
    subject(:save_flv_from_url) { util.save_flv_from_url(url, flv_path)  }
    let(:url) { 'http://www.youtube.com/watch?v=foo' }
    let(:flv_path) { '/tmp/foo.flv' }
    it 'executes youtube_dl command' do
      expect(util).to receive(:system).with("youtube-dl -q #{url} -o #{flv_path}")
      save_flv_from_url
    end
  end

  describe '.convert_flv_to_wav' do
    subject(:convert_flv_to_wav) { util.convert_flv_to_wav(flv_path, wav_path) }
    let(:flv_path) { '/tmp/foo.flv' }
    let(:wav_path) { '/tmp/foo.wav' }

    it 'executes ffmpeg command' do
      expect(util).to receive(:system).with("ffmpeg -i #{flv_path} #{wav_path} 2>/dev/null")
      convert_flv_to_wav
    end
  end
end
