require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RGet::Downloader do

  before(:each) do
    @url = 'http://www.google.com.sg'
    @file_exists = Tempfile.new('rget')
    @file_not_exists = Tempfile.name('tegr')
    @rget_exists = RGet::Downloader.new(@url, @file_exists)
    @rget_not_exists = RGet::Downloader.new(@url, @file_not_exists)
    @rget_with_parms = RGet::Downloader.new(@url, @file_not_exists, {:quiet => true, :overwrite => true})
    # downloader specific
    @axel_not_exists = RGet::AxelDownloader.new(@url, @file_not_exists)
    @wget_not_exists = RGet::WGetDownloader.new(@url, @file_not_exists)
    Kernel.stub!(:system)
  end

  describe 'being created' do

    subject { @rget_not_exists }

    it 'should raise an AppError if the URL is invalid' do
      lambda { RGet::Downloader.new('some   url87gf4^^r3&\\34', @file)}.should raise_error(RGet::AppError)
    end

    it 'should set url properly' do
      subject.url.should == @url
    end

    it 'should set file properly' do
      subject.file.should == @file_not_exists
    end

    specify { subject.should be_valid }

    it 'should allow being run with just a URL'

    describe 'without options passed' do

      it 'should default to showing output' do
        subject.options.quiet.should == false
      end

      it 'should default to not overwrite' do
        subject.options.overwrite.should == false
      end

    end

    describe 'with options passed' do

      subject { @rget_with_parms }

      it 'should support :quiet' do
        subject.options.quiet.should == true
      end

      it 'should support :overwrite' do
        subject.options.overwrite.should == true
      end

    end
  end

  describe 'downloading' do


    subject { @rget_exists }

    it 'should check if the file exists before running any downloads' do
      File.should_receive(:exists?).once
      subject.download
    end

    it 'should create the destination directory if it does not exist' # look at Dir.mktmpdir
    it 'should remove the target file if overwrite == true'
    it 'should actually do the download'

  end

  describe RGet::AxelDownloader do

    subject { @axel_not_exists }

    it 'should be creatable' do
      subject.should_not be_nil
    end

    describe 'being called' do

      it 'should run in a shell' do
        Kernel.should_receive(:system).with("#{RGet::AxelDownloader::BIN} '#{@url}' -a -o '#{@file_not_exists}'")
        subject.download
      end

      it 'should handle the :quiet parameter' do
        @dl = RGet::AxelDownloader.new(@url, @file_not_exists, { :quiet => true })
        @dl.arguments.include?('-a').should_not be_true
        @dl.download
      end

    end

  end

  describe RGet::WGetDownloader do

    subject { @wget_not_exists }

    it 'should be creatable' do
      subject.should_not be_nil
    end

    context 'being called' do

      it 'should run in a shell' do
        Kernel.should_receive(:system).with("#{RGet::WGetDownloader::BIN} '#{@url}' -c -O '#{@file_not_exists}'")
        subject.download
      end

      it 'should by default ask wget to continue existing downloads' do
        subject.arguments.include?('-c').should be_true
      end

      it 'should handle the :quiet parameter' do
        @dl = RGet::WGetDownloader.new(@url, @file_not_exists, { :quiet => true })
        @dl.arguments.include?('-q').should be_true
      end

    end

  end

end
