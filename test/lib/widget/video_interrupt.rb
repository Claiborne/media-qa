module VideoInterrupt
  
  require 'fe_checker'
  include FeChecker
  
  def widget_video_interrupt_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.vidPlayListContainer').should be_true
    end
  end
  
  def widget_video_interrupt
    
    widget_video_interrupt_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.vidPlayListContainer').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.vidPlayListContainer')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.vidPlayListContainer')
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img('div.vidPlayListContainer')
    end
    
    it "should display an image for the selected video" do
      @doc.at_css('div.vidPlayListContainer img').attribute('src').to_s.match(/http/).should be_true
    end
    
    it "should link to content for the selected video" do
      @doc.at_css('div.vidPlayListContainer a').attribute('href').to_s.match(/http/).should be_true
    end
    
    it "should display a caption for the selected video" do
      @doc.at_css('div.vidPlayListContainer div.caption').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should display three thumbnails" do
      @doc.css('div.vidPlayListContainer div.smallVids a img').count.should == 3
      @doc.css('div.vidPlayListContainer div.smallVids span.frame').count.should == 3
    end
    
    it "should not contain broken images", :spam => true do
      check_for_broken_images('div.vidPlayListContainer')
    end
    
    it "should only contain links only that return a 200", :spam => true do
      check_links_not_301_home('div.vidPlayListContainer')
    end
    
  end
end