require 'fileutils'
require 'ostruct'
require 'open-uri'
require 'pathname'
require 'pp'
require 'uri'

module RGet

  # @abstract Subclass and override {#download} to implement a custom Downloader
  class Downloader

    attr_reader :url, :file, :options

    # Create new Downloader
    # @param [Url] The URL to download
    # @param [File] Where to write the file on the local filesystem
    # @param [Options] A hash of options
    #   :progress - show progress
    #   :overwrite - overwrite target file if it exists

    def initialize(url, target, options = {})
      uri = nil
      raise RGet::AppError, "URL cannot be blank" if url.to_s.empty?
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError
        raise RGet::AppError, "URL was invalid"
      end
      @url = url
      file_from_uri = Pathname.new(uri.path).basename.to_s
      if target.to_s.empty?
        @file = file_from_uri
      elsif Dir.exists?(target)
        @file = File.join(target, file_from_uri)
      else
        @file = target
      end
      parent = Pathname.new(target).parent.to_s
      begin
        Dir.mkdir_p(parent) unless Dir.exists?(parent)
      rescue
        raise RGet::AppError, "Unable to create destination directory. Aborting..."
      end
      @options = OpenStruct.new(({:quiet => false, :overwrite => false}.merge(options)))
      @arguments = []
      build_arguments
    end

    # Perform the download
    # @return [true, false] true on success, false on error

    def download
      File.safe_unlink(@file) if File.exists?(@file) && @options.overwrite
    end

    def arguments
      @arguments.flatten.join(' ').to_s
    end

    protected
    def build_arguments
      @arguments << "'#{@url}'"
    end

  end

  class AxelDownloader < Downloader

    BIN='axel'

    def download
      super
      return Kernel.system "#{BIN} #{arguments}"
    end

    private
    def build_arguments
      super
      @arguments << (@options.quiet ? '-q' : '-a')
      @arguments << '-o'
      @arguments << "'#{@file}'"
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

  class RubyDownloader < Downloader

    def download
      raise NotImplementedError, "Sorry, RubyDownloader is not implemented yet! Make sure you have axel, wget or curl"
    end
  end

  class WGetDownloader < Downloader

    BIN='wget'

    def download
      super
      return Kernel.system "#{BIN} #{arguments}"
    end

    private
    def build_arguments
      super
      @arguments << '-q' if @options.quiet
      @arguments << '-c'
      @arguments << '-O'
      @arguments << "'#{@file}'"
    end

  end

end
