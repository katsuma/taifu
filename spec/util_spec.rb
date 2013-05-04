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
      util.should_receive(:system).with("youtube-dl -q #{url} -o #{flv_path}")
      save_flv_from_url
    end
  end

  describe '.convert_flv_to_wav' do
    subject(:convert_flv_to_wav) { util.convert_flv_to_wav(flv_path, wav_path) }
    let(:flv_path) { '/tmp/foo.flv' }
    let(:wav_path) { '/tmp/foo.wav' }

    it 'executes ffmpeg command' do
      util.should_receive(:system).with("ffmpeg -i #{flv_path} #{wav_path} 2>/dev/null")
      convert_flv_to_wav
    end
  end

  describe '.remove_flv' do
    subject(:remove_flv) { util.remove_flv(flv_path) }
    let(:flv_path) { '/tmp/foo.flv' }

    it 'executes rm command' do
      util.should_receive(:system).with("rm -f #{flv_path}")
      remove_flv
    end
  end

  describe '.execute_apple_script' do
    subject(:execute_apple_script) { util.execute_apple_script(script_path, args) }
    let(:script_path) { '/tmp/foo.scpt' }
    let(:args) { 'bar' }

    it 'executes osascript command' do
      util.should_receive(:system).with("osascript #{script_path} #{args}")
      execute_apple_script
    end
  end
end
