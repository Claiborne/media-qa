module RelatedVideos

  def check_related_videos

    it "should display once" do
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list").count.should == 1
      @selenium.find_element(:css => "div.column-supplement ul.must-watch-list").displayed?.should be_true
    end

    it "should display the header" do
      @selenium.find_element(:css => "div.column-supplement div.must-watch-header").text.should == 'RELATED VIDEOS'
    end

    it "should display eight videos" do
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li").count.should == 8
    end

    it "should have a link to for each thumb and title" do
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-thumb a img").count.should == 8
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-details a").count.should == 8
    end

    it "should display a title for all videos" do
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-details a").count.should == 8
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-details a").each do |vid|
        vid.text.strip.delete('^a-zA-Z').length.should > 0
      end
    end

    it "should display a timestamp for all videos" do
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-details div.date-time").count.should == 8
      @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list li div.must-watch-details div.date-time").each do |vid|
        vid.text.strip.delete('^a-zA-Z').length.should > 0
      end
    end

    it "should only contain links that return 200", :spam => true do
      related_vids_links =  @selenium.find_elements(:css => "div.column-supplement ul.must-watch-list a")
      related_vids_links.length.should > 8
      related_vids_links.each do |link|
        rest_client_not_301_home_open link.attribute('href').to_s
      end
    end

  end
end