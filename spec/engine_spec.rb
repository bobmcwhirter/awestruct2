
require 'awestruct/engine'

require 'hashery/open_cascade'

describe Awestruct::Engine do

  before :all do
    @site = OpenCascade.new :encoding=>false
  end

  def site_file(filename)
    File.dirname(__FILE__) + "/test-data/engine/#{filename}"
  end

  it "should be able to load a page" do
    engine = Awestruct::Engine.new
    engine.pipeline.handler_chains << :defaults

    page = engine.load_page( @site, site_file( "page-one.md" ) )
    page.should_not be_nil
    page.handler.should be_a Awestruct::Handlers::FileHandler
  end

end
