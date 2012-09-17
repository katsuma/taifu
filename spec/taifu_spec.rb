# coding: utf-8
require 'spec_helper'
require 'taifu'

describe Taifu do
  describe '#hit' do
    context 'no arguments' do
      before do
        ARGV.stub(:first).and_return(nil)
      end

      it 'should raise ArgumentError' do
        expect { Taifu.hit }.to raise_error(ArgumentError)
      end
    end
    context 'has an argument' do
      before do
        ARGV.stub(:first).and_return('dummy')
        Taifu::App.should_receive(:new)
      end

      it 'should recieve Taifu::App.new' do
        Taifu.hit
      end
    end
  end

  describe Taifu::App do
    pending 'to be implemented'
  end
end

