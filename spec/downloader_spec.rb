require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RGet::Downloader do

  before(:each) do
    @url = 'http://www.google.com.sg'
    @file_does_exist = Tempfile.new('rget')
    @file_does_not_exist = Tempfile.name('tegr')
  end

  describe 'being created' do

    it 'should raise an AppError if the URL is invalid' do
      RGet::Downloader.new('some   url87gf4^^r3&\\34', @file).should raise_error(RGet::AppError)
    end

    subject {
      RGet::Downloader.new(@url, @file_does_not_exist)
    }

    it 'should set url properly' do
      subject.url.should == @url
    end

    it 'should set file properly' do
      subject.file.should == @file_does_not_exist
    end

    it 'should allow being run with just a URL' do

    end

    describe 'with parameters' do

      subject { RGet::Downloader.new(@url, @file_does_not_exist, {}) }

      it 'should default to no progress' do
        subject.options.quiet.should == false
      end

      it 'should default to no overwrite' do
        subject.options.overwrite.should == false
      end

      subject { RGet::Downloader.new(@url, @file_does_not_exist, {:progress => true, :overwrite => true}) }

      it 'should support :quiet' do
        subject.options.progress.should == true
      end

      it 'should support :overwrite' do
        subject.options.overwrite.should == true
      end

    end
  end

  describe 'downloading' do

    subject {
      Kernel.stub!(:system)
      RGet::Downloader.new(@url, @file_does_exist)
    }

    it 'should check if the file exists before running any downloads' do
      File.should_receive(:exists?).once
      subject.download
    end

    it 'should create the destination directory if it does not exist' # look at Dir.mktmpdir
    it 'should remove the target file if overwrite == true'
    it 'should actually do the download'

  end

  describe RGet::AxelDownloader do
    subject {
      Kernel.stub!(:system)
      RGet::AxelDownloader.new(@url, @file_does_not_exist)
    }

    it 'should be creatable' do
      subject.should_not be_nil
    end

    describe 'being called' do

      it 'should run in a shell' do
        Kernel.should_receive(:system).with("#{RGet::AxelDownloader::BIN} '#{@url}' -a -o '#{@file_does_not_exist}'")
        subject.download
      end

      it 'should handle the :progress parameter' do
        @dl = RGet::AxelDownloader.new(@url, @file_does_not_exist, { :progress => true })
        @dl.arguments.include?('-a').should be_true
        @dl.download
      end

    end

  end

  describe RGet::WGetDownloader do

    subject {
      Kernel.stub!(:system)
      RGet::WGetDownloader.new(@url, @file_does_not_exist)
    }

    it 'should be creatable' do
      subject.should_not be_nil
    end

    describe 'being called' do

      it 'should happen in a shell' do
        Kernel.should_receive(:system).with("#{RGet::WGetDownloader::BIN} '#{@url}' -c -O '#{@file_does_not_exist}'")
        subject.download
      end

      it 'should by default ask wget to continue existing downloads' do
        subject.arguments.include?('-c').should be_true
      end

      it 'should handle the :progress parameter' do
        @dl = RGet::WGetDownloader.new(@url, @file_does_not_exist, { :progress => true })
        @dl.arguments.include?('-q').should be_false
      end

    end

  end

end