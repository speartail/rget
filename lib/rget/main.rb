require 'fileutils'
require 'open-uri'

module RGet

  # we are keeping this in an array because the ordering matters
  DOWNLOADERS = [
    {
      :bin => 'axel',
      :arg => '-a -o'
    },
    {
      :bin => 'curl',
      :arg => '--progress-bar -o'
    },
    {
      :bin => 'wget',
      :arg => '-c -O'
    }
  ]

  class Main

    def initialize(arguments)

      @args = arguments
      @dl = nil

    end

    def download(url, file)
      if @dl
        system "#{dl[:bin]} #{url} #{dl[:arg]} #{file}"
      else

      end
    end

    private
    def choose_downloader
      DOWNLOADERS.each do |dl|
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |d|
          f = File.join(d, dl[:bin])
          return dl if File.exist?(f)
        end
      end
      return nil
    end

  end

end