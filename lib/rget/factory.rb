require 'optparse'
require 'pp'

module RGet

  class Factory

    def self.factory(url, file, options)

      return RGet::AxelDownloader.new(url, file, options) if check_binary_downloader(RGet::AxelDownloader::BIN)
      return RGet::CurlDownloader(url, file, options) if check_ruby_downloader(:curl)
      return RGet::WGetDownloader.new(url, file, options) if check_binary_downloader(RGet::WGetDownloader::BIN)
      return RGet::RubyDownloader(url, file, options)
      
    end

    private
    def self.check_binary_downloader(bin)
      ENV['PATH'].split(File::PATH_SEPARATOR).each { |dir| return true if File.exist?(File.join(dir, bin)) }
      false
    end

    def self.check_ruby_downloader(type)
      case type
        when :curl
        begin
          require 'curl-multi'
        rescue LoadError
          return false
        end
      end
      true
    end

  end

end
