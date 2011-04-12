require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RGet::Downloader do

  before(:each) do
    @url = 'http://www.google.com.sg'
    t = Tempfile.new('rget')
    @file_does_not_exist = t.path
    t.close!
    @file_does_exist = Tempfile.new('rget')
    File.safe_unlink(@file_does_not_exist) if File.exists?(@file_does_not_exist)
  end

  describe 'being created' do

    it 'should raise an AppError if the URL is invalid' do
      pending {RGet::Downloader.new('someurl87gf4^^r3&\\34', @file).should raise_error(RGet::AppError)}
    end

    it 'should set url properly' do
      d = RGet::Downloader.new(@url, @file_does_not_exist)
      d.url.should == @url
    end

    it 'should set file properly' do
      d = RGet::Downloader.new(@url, @file_does_not_exist)
      d.file.should == @file_does_not_exist
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

    it 'should create the destination directory if it does not exist'
    it 'should remove the target file if overwrite == true'
    it 'should actually do the download'
    
  end

end