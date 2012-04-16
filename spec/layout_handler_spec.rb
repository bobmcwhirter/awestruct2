
require 'awestruct/handlers/layout_handler'
require 'awestruct/handlers/string_handler'
require 'awestruct/engine'
require 'awestruct/handler_chains'
require 'awestruct/site'
require 'awestruct/page'
require 'awestruct/page_loader'

require 'hashery/open_cascade'
require 'ostruct'

describe Awestruct::Handlers::LayoutHandler do


  before :all do
    @config = OpenCascade.new( :dir=>Pathname.new( File.dirname(__FILE__) + '/test-data/handlers' ) )
    @engine = Awestruct::Engine.new
    @engine.pipeline.handler_chains << :defaults
    @site = Awestruct::Site.new( @engine, @config )
    layout_loader = Awestruct::PageLoader.new( @site, :layouts )
    puts @config.dir
    layout = layout_loader.load_page( File.join( @config.dir, 'haml-layout.html.haml' ) )
    layout.class.should == Awestruct::Page
    layout.should_not be_nil

    @site.layouts << layout

    layout = layout_loader.load_page( File.join( @config.dir, 'haml-layout-two.html.haml' ) )
    layout.class.should == Awestruct::Page
    layout.should_not be_nil

    @site.layouts << layout
  end

  it "should be able to find layouts by simple name" do
    layout = @site.layouts[ 'haml-layout' ]
    layout.class.should == Awestruct::Page
  end

  it "should apply the layout to its delegate's content" do
    primary_handler = Awestruct::Handlers::StringHandler.new( @site, "this is the content" )
    layout_handler = Awestruct::Handlers::LayoutHandler.new( @site, primary_handler )

    page = Awestruct::Page.new( @site, layout_handler )

    context = page.create_context
    context.page.layout = 'haml-layout'

    @site.layouts['haml-layout'].should_not be_nil
    rendered = layout_handler.rendered_content( context )
    
  end

  it "should recursively apply the layout to its delegate's content" do
    primary_handler = Awestruct::Handlers::StringHandler.new( @site, "this is the content" )
    layout_handler = Awestruct::Handlers::LayoutHandler.new( @site, primary_handler )

    page = Awestruct::Page.new( @site, layout_handler )

    context = page.create_context
    puts "context #{context.class}"
    puts "context.page #{context.page.class}"
    puts "context.page.layout #{context.page.layout}"
    context.page.layout = 'haml-layout-two'

    @site.layouts['haml-layout'].should_not be_nil
    rendered = layout_handler.rendered_content( context )

    puts "---"
    puts rendered
    puts "---"
  end

end
