module AddThis

  def check_add_this

    it "should be on the page once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style']").count.should == 1
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style']").displayed?.should be_true
    end

    it "should display the Facebook button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Facebook'] span").count.should == 2
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Facebook'] span").displayed?.should be_true
    end

    it "should display the Twitter button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Tweet'] span").count.should == 2
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Tweet'] span").displayed?.should be_true
    end

    it "should display the Reddit button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Reddit'] span").count.should == 2
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Reddit'] span").displayed?.should be_true
    end

    it "should display the Tumblr button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Tumblr'] span").count.should == 2
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Tumblr'] span").displayed?.should be_true
    end

    it "should display the Google+ button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Google+'] span").count.should == 2
      @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a[title='Google+'] span").displayed?.should be_true
    end

    it "should display the More+ button once" do
      @selenium.find_elements(:css => "div[class='addthis_toolbox addthis_default_style'] a.addthis_button").count.should == 1
      more = @selenium.find_element(:css => "div[class='addthis_toolbox addthis_default_style'] a.addthis_button")
      more.attribute('href').to_s.should == "http://www.addthis.com/bookmark.php"
      more.displayed?.should be_true
      more.text.should == 'MORE +'
    end

  end
end