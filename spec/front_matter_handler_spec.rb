require 'fileutils'

require 'awestruct/inputs/file_input'
require 'awestruct/handlers/front_matter_handler'

describe Awestruct::Handlers::FrontMatterHandler do

  before :all do
    @site = OpenCascade.new :encoding=>false
  end

  it "should be able to split front-matter from content" do 
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/front-matter-file.txt" )
    input = Awestruct::Inputs::FileInput.new( @site, filename )
    handler = Awestruct::Handlers::FrontMatterHandler.new( @site, input )
    handler.front_matter.should_not be_nil
    handler.front_matter['foo'].should == 'bar'
    handler.raw_content.strip.should == 'This is some content'
  end

  it "should be able to split front-matter from content for files without actual front-matter" do 
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/front-matter-file-no-front.txt" )
    input = Awestruct::Inputs::FileInput.new( @site, filename )
    handler = Awestruct::Handlers::FrontMatterHandler.new( @site, input )
    handler.front_matter.should_not be_nil
    handler.front_matter.should be_empty
    handler.raw_content.strip.should == 'This is some content'
  end

  it "should be able to split front-matter from content for files without actual content" do 
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/front-matter-file-no-content.txt" )
    input = Awestruct::Inputs::FileInput.new( @site, filename )
    handler = Awestruct::Handlers::FrontMatterHandler.new( @site, input )
    handler.front_matter.should_not be_nil
    handler.front_matter['foo'].should == 'bar'
    handler.raw_content.should be_nil
  end

end

