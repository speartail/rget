module RGet

  class CLI

    def self.run(arguments)
      rget = RGet::Main.new(arguments)
      rget.run
    end

  end

end
