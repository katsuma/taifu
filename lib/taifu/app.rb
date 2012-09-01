# coding: utf-8
module Taifu
  include Appscript

  class App
    REQUIRED_APPS = ['youtube-dl', 'ffmpeg']

    def initialize(url)
      return unless satisfied?

      init_working_dir

      save_wav_with(url)
      add_track

      logging "Done. Type 'taifu' on your iTunes", false
    end

    def init_working_dir
      unless File.exist?(working_dir)
        FileUtils.mkdir(working_dir)
      end
    end

    def working_dir
      home_dir = File.expand_path('~')
      File.join(home_dir, '.taifu')
    end

    def add_track
      logging 'Add wav file to iTunes'

      script = create_script
      `osascript #{script}`
      delete_script

      delete_wav
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

    def save_wav_with(youtube_url)
      url = youtube_url.split('&').first
      wav_file = 'taifu.wav'
      wav_path = "#{working_dir}/#{wav_file}"

      logging 'Download data'
      system "youtube-dl -q #{url} -o #{working_dir}/taifu.flv"

      logging 'Save wav file'
      system "ffmpeg -i #{working_dir}/taifu.flv #{wav_path} 2>/dev/null"
      system "rm -f #{working_dir}/taifu.flv"
    end

    def satisfied?
      REQUIRED_APPS.each do |app|
        if `which #{app}`.empty?
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

    def logging(message, caption=true)
      if caption
        puts "[#{message}]..." if ENV['LOGGING']
      else
        puts message
      end
    end

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

  end
end
