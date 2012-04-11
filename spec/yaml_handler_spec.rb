
require 'hashery/open_cascade'
require 'awestruct/inputs/file_input'
require 'awestruct/handlers/yaml_handler'

describe Awestruct::Handlers::YamlHandler do

  before :all do
    @site = OpenCascade.new :encoding=>false
  end

  it "should interpolate content when rendered" do 
    filename = Pathname.new( File.dirname(__FILE__) + "/test-data/simple-data.yaml" )
    input = Awestruct::Inputs::FileInput.new( @site, filename )
    handler = Awestruct::Handlers::YamlHandler.new( @site, input )
    handler.raw_content.should be_nil
    handler.front_matter['taco'].should == 'deluxe'
  end

end

