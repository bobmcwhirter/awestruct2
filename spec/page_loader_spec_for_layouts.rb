require 'awestruct/engine'
require 'awestruct/site'
require 'awestruct/page_loader'
require 'awestruct/config'

describe Awestruct::PageLoader do

  before :each do
    @config = Awestruct::Config.new( File.dirname(__FILE__) + "/test-data/page-loader" )
    @engine = Awestruct::Engine.new
    @engine.pipeline.handler_chains << :defaults
    @site   = Awestruct::Site.new( @engine, @config )
    @loader = Awestruct::PageLoader.new( @site, @config, :layouts )
  end

  it "should be able to load a site layout" do
    page = @loader.load_page( File.join( @config.dir, "_layouts", "layout-one.md" ) )
    page.should_not be_nil
    page.handler.should be_a Awestruct::Handlers::MarkdownHandler
    page.relative_source_path.to_s.should == "/_layouts/layout-one.md" 
  end

  it "should be able to load all site layouts" do
    @loader.load_all
    @site.layouts.size.should == 2

    @site.layouts.sort!{|l,r| l.relative_source_path <=> r.relative_source_path }

    @site.layouts[0].relative_source_path.should == '/_layouts/layout-one.md'
    @site.layouts[0].output_path.should          == '/_layouts/layout-one.html'

    @site.layouts[1].relative_source_path.should == '/_layouts/layout-two.html.haml'
    @site.layouts[1].output_path.should          == '/_layouts/layout-two.html'
  end

end
