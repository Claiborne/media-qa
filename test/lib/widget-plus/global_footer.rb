module GlobalFooter

  def check_global_footer

    it "should display once" do
      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-topRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-topRow").displayed?.should be_true

      @selenium.find_elements(:css => "div#ignFooter-container div.ignFooter-bottomRow").count.should == 1
      @selenium.find_element(:css => "div#ignFooter-container div.ignFooter-bottomRow").displayed?.should be_true
    end

  end
end