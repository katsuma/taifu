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
      wav_file = 'taifu.wav'
      wav_path = "#{working_dir}/#{wav_file}"

      @logger.info 'Download data'
      download_from url

      @logger.info 'Save wav file'
      convert_flv_to wav_path
      remove_flv

      wav_path
    end

    def add_track(wav_path, clean_up: true)
      @logger.info 'Add wav file to iTunes'

      unless File.exist?(wav_path)
        raise ArgumentError.new 'Not found wav file'
      end

      script_path = File.expand_path('./scripts/add_track.scpt')
      expand_wav_path = File.expand_path(wav_path)
      execute_script(script_path, expand_wav_path)

      FileUtils.rm_f(wav_path) if clean_up

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
      !`which #{app}`.empty?
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

    def download_from(url)
      system "youtube-dl -q #{url} -o #{working_dir}/taifu.flv"
    end
    private :download_from

    def convert_flv_to(wav)
      system "ffmpeg -i #{working_dir}/taifu.flv #{wav} 2>/dev/null"
    end
    private :convert_flv_to

    def remove_flv
      system "rm -f #{working_dir}/taifu.flv"
    end
    private :remove_flv

    def execute_script(script, args)
      `osascript #{script} #{args}`
    end
    private :execute_script
  end
end
