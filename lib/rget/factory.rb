module RGet

  class Factory

    def self.factory
      [ 'axel', 'wget' ].each
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
