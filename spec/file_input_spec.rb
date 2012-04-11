require 'fileutils'

require 'awestruct/inputs/file_input'

describe Awestruct::Inputs::FileInput do

  it "should be able to read a valid absolute file input" do
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    input = Awestruct::Inputs::FileInput.new( nil, filename )
    content = input.read
    content.strip.should == 'howdy'
  end

  it "should be able to read a valid relative file input" do
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    pwd = Pathname.new( Dir.pwd )
    input = Awestruct::Inputs::FileInput.new( nil, filename.relative_path_from( pwd ) )
    content = input.read
    content.strip.should == 'howdy'
  end

  it "should be stale before being read" do
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    input = Awestruct::Inputs::FileInput.new( nil, filename )
    input.should be_stale
  end

  it "should not be stale after being read" do
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    input = Awestruct::Inputs::FileInput.new( nil, filename )
    content = input.read
    content.strip.should == 'howdy'
    input.should_not be_stale
  end

  it "should be stale if touched after being read" do
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    input = Awestruct::Inputs::FileInput.new( nil, filename )
    content = input.read
    content.strip.should == 'howdy'
    input.should_not be_stale
    sleep(1)
    FileUtils.touch( filename )
    input.should be_stale
  end

end

