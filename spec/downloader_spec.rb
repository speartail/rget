require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RGet::Downloader do

  before(:each) do
    @url = 'http://www.google.com.sg'
    @file_does_exist = Tempfile.new('rget')
  #    @file_does_not_exist = gen_tmp_file_name('tegr')
    @file_does_not_exist = Tempfile.name('tegr')
  end

  describe 'being created' do

    it 'should raise an AppError if the URL is invalid' do
      pending { RGet::Downloader.new('someurl87gf4^^r3&\\34', @file).should raise_error(RGet::AppError) }
    end

    it 'should set url properly' do
      d = RGet::Downloader.new(@url, @file_does_not_exist)
      d.url.should == @url
    end

    it 'should set file properly' do
      d = RGet::Downloader.new(@url, @file_does_not_exist)
      d.file.should == @file_does_not_exist
    end

    describe 'with parameters' do

      before(:each) { @dl = RGet::Downloader.new(@url, @file_does_not_exist, {}) }

      it 'should default to no progress' do
        @dl.options.quiet.should == false
      end

      it 'should default to no overwrite' do
        @dl.options.overwrite.should == false
      end

      it 'should support :quiet' do
        @dl = RGet::Downloader.new(@url, @file_does_not_exist, {:progress => true})
        @dl.options.progress.should == true
      end

      it 'should support :overwrite' do
        @dl = RGet::Downloader.new(@url, @file_does_not_exist, {:overwrite => true})
        @dl.options.overwrite.should == true
      end

    end
  end

  describe 'downloading' do

    before(:each) do
      @dl = RGet::Downloader.new(@url, @file_does_exist)
    end

    it 'should check if the file exists before running any downloads' do
      File.should_receive(:exists?).once
      @dl.download
    end

    it 'should create the destination directory if it does not exist' # look at Dir.mktmpdir
    it 'should remove the target file if overwrite == true'
    it 'should actually do the download'

  end

  describe RGet::AxelDownloader do
    subject {
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
        @dl.download
      end

    end

  end

end