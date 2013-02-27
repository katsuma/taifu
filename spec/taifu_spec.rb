# coding: utf-8
require 'spec_helper'
require 'taifu'

describe Taifu do
  let(:url) { 'http://www.youtube.com/watch?v=I1X6MrBfjrk' }

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
        let(:working_dir) { '/tmp/.taifu' }

        before do
          taifu.should_receive(:installed?).exactly(2).times.and_return(true)
          taifu.should_receive(:working_dir).and_return(working_dir)
        end

        it 'makes a working directory', fakefs: true do
          subject
          File.should exist(working_dir)
        end
      end
    end

    describe '#save_as_wav_with' do
      subject do
        taifu = Taifu::App.new
        taifu.save_as_wav_with(load_url)
      end

      let(:load_url) { "#{url}&fature=endscreen" }
      let(:working_dir) { '/tmp/.taifu' }
      let(:taifu) { Taifu::App.any_instance }

      before do
        taifu.should_receive(:installed?).exactly(2).times.and_return(true)
        taifu.should_receive(:working_dir).at_least(:once).and_return(working_dir)
      end

      it 'saves file as wav' do
        taifu.should_receive(:download_from).with(url)
        taifu.should_receive(:convert_flv_to).with("#{working_dir}/taifu.wav")
        taifu.should_receive(:remove_flv)
        subject
      end

    end
  end
end
