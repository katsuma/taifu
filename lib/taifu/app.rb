# coding: utf-8
module Taifu
  class App
    REQUIRED_APPS = %w(youtube-dl ffmpeg).freeze

    def initialize
      init_working_dir if check_env
      @logger = Logger.new("#{working_dir}/taifu.log")
    end

    def save_as_wav_with(youtube_url)
      url = youtube_url.split('&').first
      flv_path = "#{working_dir}/taifu.flv"
      wav_file = 'taifu.wav'
      wav_path = "#{working_dir}/#{wav_file}"

      FileUtils.rm_f(wav_path) if File.exist?(wav_path)

      @logger.info 'Download data'
      Util.save_flv_from_url(url, flv_path)

      @logger.info 'Save wav file'
      Util.convert_flv_to_wav(flv_path, wav_path)
      FileUtils.rm_f(flv_path)

      wav_path
    end

    def add_track(wav_path, clean_up = true)
      @logger.info 'Add wav file to iTunes'

      unless File.exist?(wav_path)
        raise ArgumentError.new 'Not found wav file'
      end

      track = Itunes::Player.add(wav_path)
      converted_track = track.convert
      converted_track.update_attributes(name: 'Taifu')
      track.delete! if clean_up
      FileUtils.rm_f(wav_path)
      @logger.info "Done. Type 'taifu' on your iTunes"
    end

    def check_env
      REQUIRED_APPS.each do |app|
        unless installed?(app)
          messages = []
          messages << "'#{app}' is not installed."
          messages << "Try this command to install '#{app}'."
          messages << ""
          messages << "   brew install #{app}"
          messages << ""
          raise RuntimeError, messages.join("\n")
        end
      end
      true
    end
    private :check_env

    def installed?(app)
      !!(system "which #{app}")
    end
    private :installed?

    def working_dir
      home_dir = File.expand_path('~')
      File.join(home_dir, '.taifu')
    end
    private :working_dir

    def init_working_dir
      unless File.exist?(working_dir)
        FileUtils.mkdir(working_dir)
      end
    end
    private :init_working_dir
  end
end
