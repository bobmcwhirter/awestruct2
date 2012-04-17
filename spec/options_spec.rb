
require 'awestruct/cli/options'

describe Awestruct::CLI::Options do

  before :each do
    @options = Awestruct::CLI::Options.new
  end

  it "should have reasonable defaults" do
    @options.generate.should == true
    @options.server.should   == false
    @options.deploy.should   == false

    @options.port.should      == 4242
    @options.bind_addr.should == '0.0.0.0'

    @options.auto.should  == false
    @options.force.should == false
    @options.init.should  == false

    @options.framework.should == 'compass'
    @options.scaffold.should == true

    @options.base_url.should == nil
    @options.profile.should  == nil
    @options.script.should   == nil
  end

end
