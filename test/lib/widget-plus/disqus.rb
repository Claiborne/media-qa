module Disqus

  def check_disqus

    it "should display once" do
      @selenium.find_elements(:css => "div#disqus_thread").count.should == 1
      @selenium.find_elements(:css => "div#disqus_thread iframe").count.should == 4
      @selenium.find_element(:css => "div#disqus_thread iframe#dsq2").displayed?.should be_true
    end

  end
end