# coding: utf-8
module Taifu
  class Util
    def self.save_flv_from_url(url, flv_path)
      system "youtube-dl -q #{url} -o #{flv_path}"
    end

    def self.convert_flv_to_wav(flv_path, wav_path)
      system "ffmpeg -i #{flv_path} #{wav_path} 2>/dev/null"
    end
  end
end
