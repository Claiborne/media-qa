module VideoInterrupt
  
  def widget_video_interrupt
    
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.vidPlayListContainer').should be_true
    end
    
    it "should appear once on the page", :code => true do
      @doc.css('div.vidPlayListContainer').count.should == 1
    end
    
    it "should display an image for the selected video", :code => true do
      @doc.at_css('div.vidPlayListContainer img').attribute('src').to_s.match(/http/).should be_true
    end
    
    it "should link to content for the selected video", :code => true do
      @doc.at_css('div.vidPlayListContainer a').attribute('href').to_s.match(/http/).should be_true
    end
    
    it "should display a caption for the selected video", :code => true do
      @doc.at_css('div.vidPlayListContainer div.caption').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should display three thumbnails", :code => true do
      @doc.css('div.vidPlayListContainer div.smallVids a img').count.should == 3
      @doc.css('div.vidPlayListContainer div.smallVids span.frame').count.should == 3
    end
    
    it "should not contain broken images" do
      @doc.css('div.vidPlayListContainer img').each do |img|
        img_src = img.attribute('src').to_s
        response = rest_client_open img_src
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end
    
    it "should not contain broken links" do
      @doc.css('div.vidPlayListContainer a').each do |a|
        a_href = a.attribute('href').to_s
        response = rest_client_open a_href
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end
    
  end
end