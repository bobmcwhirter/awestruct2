
require 'awestruct/layouts'
require 'awestruct/page'
require 'awestruct/handlers/file_handler'
require 'awestruct/handlers/haml_handler'

require 'hashery/open_cascade'

describe Awestruct::Layouts do

  it "should be able to index layouts by simple name" do
    dir = Pathname.new( File.dirname( __FILE__ ) + '/test-data/handlers' )
    site = OpenCascade.new( :dir=>dir )
    file_handler = Awestruct::Handlers::FileHandler.new( site, File.join( dir, 'haml-layout.html.haml' ) )
    haml_handler = Awestruct::Handlers::HamlHandler.new( site, file_handler )
    page = Awestruct::Page.new( nil, haml_handler )
    
    layouts = Awestruct::Layouts.new
    layouts << page

    located = layouts[0]
    located.should_not be_nil
    located.class.should == Awestruct::Page
    located.simple_name.should == 'haml-layout'

    located = layouts[ 'haml-layout' ]
    located.should_not be_nil
    located.class.should == Awestruct::Page
    located.simple_name.should == 'haml-layout'
  end

end
