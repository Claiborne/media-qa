re File.dirname(__FILE__) + "/../spec_helper"
require 'browser'

describe "blogs" do

  before(:all) do

  end

  before(:each) do
   Configuration.config_path = File.dirname(__FILE__) + "/../../config/oyster/oyster_media.yml"
   @config = Configuration.new
   @browser = Browser.new
  end

  after(:each) do
   @browser.shutdown
  end


end
~                                                                             
~            
