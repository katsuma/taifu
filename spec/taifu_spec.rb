# coding: utf-8
require 'spec_helper'
require 'taifu'

describe Taifu do
  let(:url) { 'http://www.youtube.com/watch?v=I1X6MrBfjrk' }
  let(:working_dir) { '/tmp/.taifu' }
  let(:util) { Taifu::Util  }

  describe '#hit' do
    context 'with no arguments' do
      before do
        ARGV.stub(:first).and_return(nil)
      end

      it 'raises an ArgumentError' do
        expect { Taifu.hit }.to raise_error(ArgumentError)
      end
    end

    context 'with an argument' do
      before do
        ARGV.stub(:first).and_return(url)
      end

      it 'recieves Taifu::App.new' do
        taifu = double('taifu')
        taifu.should_receive(:save_as_wav_with)
        taifu.should_receive(:add_track)

        Taifu::App.should_receive(:new).and_return(taifu)
        Taifu.hit
      end
    end
  end

  describe Taifu::App do
    describe '.new' do
      subject { Taifu::App.new }

      let(:taifu) { Taifu::App.any_instance }
      let(:app) { 'youtube-dl' }

      context "if required app is not installed" do
        before do
          taifu.should_receive(:installed?).with(app).and_return(false)
        end

        it 'raises an RuntimeError' do
          expect { subject }.to raise_error(RuntimeError)
        end
      end

      context 'if required apps are installed' do

        before do
          taifu.should_receive(:installed?).at_least(:twice).and_return(true)
          FileUtils.rm_rf(working_dir)
        end

        it 'makes a working directory', fakefs: true do
          taifu.should_receive(:working_dir).at_least(:twice).and_return(working_dir)
          expect { subject }.to change { File.exist?(working_dir) }.from(false).to(true)
        end
      end
    end

    describe '#save_as_wav_with' do
      subject do
        taifu = Taifu::App.new
        taifu.save_as_wav_with(load_url)
      end

      let(:load_url) { "#{url}&fature=endscreen" }
      let(:taifu) { Taifu::App.any_instance }

      before { stub_app_installed }

      it 'saves file as wav' do
        util.should_receive(:save_flv_from_url)
        util.should_receive(:convert_flv_to_wav)

        subject
      end
    end

    describe '#add_track' do
      subject(:add_track) do
        taifu = Taifu::App.new
        taifu.add_track(wav_path)
      end

      let(:taifu) { Taifu::App.any_instance }
      let(:wav_path) { '/tmp/.taifu.wav' }

      before { stub_app_installed }

      context 'if wav file is not found' do
        before do
          FileUtils.rm_rf(wav_path)
        end

        it 'raises ArgumentError', fakefs: true do
          expect { add_track }.to raise_error(ArgumentError)
        end
      end

      context 'if wav file is found' do
        before do
          FileUtils.touch(wav_path)
        end

        let(:track) { Itunes::Track.new }
        let(:converted_track) { Itunes::Track.new }

        it 'calls Itunes util methods', fakefs: true do
          Itunes::Player.stub(:add).with(wav_path).and_return(track)
          track.should_receive(:convert).and_return(converted_track)
          converted_track.should_receive(:update_attributes)
          track.should_receive(:delete!)

          add_track
        end
      end
    end

    def stub_app_installed
      taifu.should_receive(:system).with(/^which/).exactly(2).times.and_return(true)
    end
  end
end
