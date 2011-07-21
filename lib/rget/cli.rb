module RGet

  # TODO: :quiet vs :progress

  class CLI

    def self.run(arguments)
      show_help = false
      opts = OptionParser.new
      opts.banner = "#{PROGRAM_NAME} [OPTIONS] url [file]"
      opts.program_name=PROGRAM_NAME
      opts.on('-h', '--help', 'Show this screen') { show_help = true }
      options = {}
      options[:downloader] = :axel
      opts.on('-d', '--downloader [DOWNLOADER]', [:axel, :curl, :wget, :ruby ], 'Force downloader (axel, curl, wget, ruby)') do |arg|
        options[:downloader] = arg.to_s.downcase.to_sym
        raise NotImplementedError, "Sorry, not implemented yet!"
      end
      options[:quiet] = false
      opts.on('-q', '--quiet', 'Do not show progress') { options[:quiet] = true }
      options[:overwrite] = false
      opts.on('-w', '--write', 'Overwrite existing files') { options[:overwrite] = true }
      begin
        opts.parse!(arguments)
      rescue
        show_help = true
      end
      show_help = true unless [1, 2].include?(arguments.length)
      url = arguments[0]
      file = arguments[1] if arguments[1]
      if show_help
        help(opts)
        exit 1
      end
      rget = RGet::Factory.factory(url, file, options)
      rget.download unless rget.nil?
    end

    def self.help(options)
      puts options.help
    end

  end

end
