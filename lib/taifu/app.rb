# coding: utf-8
module Taifu
  class App
    REQUIRED_APPS = %w(youtube-dl ffmpeg).freeze

    def initialize
      init_working_dir if check_env
      @logger = Logger.new(STDOUT)
    end

    def init_working_dir
      unless File.exist?(working_dir)
        FileUtils.mkdir(working_dir)
      end
    end

    def add_track
      @logger.info 'Add wav file to iTunes'

      script = create_script
      `osascript #{script}`
      delete_script

      delete_wav
      @logger.info "Done. Type 'taifu' on your iTunes"
    end

    def delete_wav
      FileUtils.rm "#{working_dir}/taifu.wav"
    end

    def delete_script
      FileUtils.rm "#{working_dir}/track.scpt"
    end

    def create_script
      file_path = MacTypes::FileURL.path(File.expand_path("#{working_dir}/taifu.wav")).hfs_path
      script_path = "#{working_dir}/track.scpt"

      script = script_base.gsub('$file_path', file_path)
      open(script_path, 'w') do |f|
        f.write script
      end
      script_path
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

    def script_base
<<-SCRIPT
tell application "iTunes"
  set added_track to add "$file_path"
  set loc to (get location of added_track)
  convert added_track
  delete added_track

  tell application "Finder"
    delete loc
  end tell
end tell
SCRIPT
    end
    private :script_base
  end
end
