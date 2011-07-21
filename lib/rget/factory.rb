require 'optparse'
require 'pp'

module RGet

  class Factory

    def self.factory(url, file, options)

      return RGet::AxelDownloader.new(url, file, options) if check_downloader(:axel)
      return RGet::CurlDownloader(url, file, options) if check_downloader(:curl)
      return RGet::WGetDownloader.new(url, file, options) if check_downloader(:rget)
      return RGet::RubyDownloader(url, file, options)
      
    end

    private
    def self.check_downloader(type)
      return case type
        when :axel
          check_binary_downloader(RGet::AxelDownloader::BIN)
        when :curl
        begin
          require 'curl-multi'
        rescue LoadError
          return false
        end
        when :ruby
        true
        when :wget
          check_binary_downloader(RGet::WGetDownloader::BIN)
        else
        false
      end
    end

    def self.check_binary_downloader(bin)
      ENV['PATH'].split(File::PATH_SEPARATOR).each { |dir| return true if File.exist?(File.join(dir, bin)) }
      false
    end

  end

end
