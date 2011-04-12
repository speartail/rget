require 'fileutils'
require 'ostruct'
require 'open-uri'
require 'uri'

module RGet

  class Downloader

    attr_reader :url, :file, :options

    def initialize(url, file, options = {})
      raise RGet::AppError, "URL cannot be blank" if url.to_s.empty?
      raise RGet::AppError, "File cannot be blank" if file.to_s.empty?
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        raise RGet::AppError, "URL was invalid"
      end
      @url = url
      @file = file
      @options = OpenStruct.new({:verbose => false, :overwrite => false}.merge(options))
    end

    def download
      File.safe_unlink(@file) if File.exists?(@file) && @options.overwrite
    end

    class AxelDownloader < Downloader

      BIN='axel'

      def download
        super
        return system "#{BIN} '#{@url}' -a -o '#{@file}"
      end

    end

    class CurlDownloader < Downloader

      BIN='curl'

      def download
        super
        begin
          require 'curl-multi'
          curl = Curl::Multi.new
          on_success = lambda { |body| File.open(@file, 'w') { |f| f.write(body) } }
          on_failure = lambda { |ex| return false }
          curl.get(@url, on_success, on_failure)
          curl.select([], []) while curl.size > 0
        rescue
          File.safe_unlink(@file) if File.exists?(@file)
          return false
        end
      end

    end

    class WGetDownloader < Downloader

      BIN='wget'

      def download
        super
        return system "#{BIN} -c '#{@url}' -O '#{@file}"
      end

    end

  end

end