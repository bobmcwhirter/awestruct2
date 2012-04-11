
require 'awestruct/inputs/string_input'
require 'awestruct/handlers/interpolation_handler'

describe Awestruct::Handlers::InterpolationHandler do

  before :all do
    @site = OpenCascade.new :encoding=>false
  end

  it "should interpolate content when rendered" do 
    input = Awestruct::Inputs::StringInput.new( @site, 'This is #{cheese}' )
    handler = Awestruct::Handlers::InterpolationHandler.new( @site, input )
    context = OpenCascade.new :cheese=>'swiss' 
    content = handler.rendered_content( context )
    content.should == 'This is swiss'
  end

end

