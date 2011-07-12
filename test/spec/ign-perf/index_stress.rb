require File.dirname(__FILE__) + "/../spec_helper"
require 'utils'

describe "ign stress test" do

  before(:all) do

  end

  before(:each) do

  end

  after(:each) do

  end

  it "should support large amount of traffic" do
   Utils::run(File.dirname(__FILE__) + "/../../performance/ign/index_stress.sh" , true, "running ign stress test") 
  end

end
