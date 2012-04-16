require 'spec_helper'
require 'fileutils'

require 'awestruct/page'
require 'awestruct/handlers/file_handler'

describe Awestruct::Handlers::FileHandler do

  before :all do
    @site = OpenCascade.new :encoding=>false

  end

  before :each do
    @filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-file.txt" )
    @handler = Awestruct::Handlers::FileHandler.new( @site, @filename )
    @page = Awestruct::Page.new( @site, @handler )
  end

  it "should be stale before being read" do
    @page.should be_stale
  end

  it "should not be stale after being read" do
    @page.raw_content.strip.should == 'howdy'
    @page.should_not be_stale
  end

  it "should be stale if touched after being read" do
    @page.raw_content.strip.should == 'howdy'
    @page.should_not be_stale
    sleep(1)
    FileUtils.touch( @filename )
    @page.should be_stale
  end

  it "should be stale if a dependency is stale" do
    @page.should be_stale
    @page.raw_content.strip.should == 'howdy'

    stale_dep = mock( 'dependency' )
    stale_dep.should_receive( :stale? ).and_return( true )

    @page.should_not be_stale
    @page.dependencies << stale_dep
    @page.should be_stale
  end

  it "should be able to create an appropriate context" do
    context = @page.create_context
    context.site.should == @site
    context.page.should == @page
    context.content.should == ''
  end

end

