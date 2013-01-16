module GlobalHeaderNav

  def check_global_header_nav

    it "should display the global header once" do
      @selenium.find_elements(:css => "div#ignHeader div#ignHeader-userBar").count.should == 1
      @selenium.find_element(:css => "div#ignHeader div#ignHeader-userBar").displayed?.should be_true
    end

    it "should display the global nav once" do
      @selenium.find_elements(:css => "div#ignHeader div#ignHeader-navigation").count.should == 1
      @selenium.find_element(:css => "div#ignHeader div#ignHeader-navigation").displayed?.should be_true
    end

  end
end