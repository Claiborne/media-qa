module TagCoverStories
  
  require 'link_checker'
  include LinkChecker
  
  def widget_tag_cover_stories_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.tgs-topStories div.tgs-storyItems').count.should == 1
    end
  end
  
  def widget_tag_cover_stories
    
    widget_tag_cover_stories_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.tgs-topStories div.tgs-storyItems').should be_true
    end

    it "should have three slots for three stories" do
      @doc.css('div.tgs-topStories div.tgs-storyItems ul li').count.should == 3
    end
    
    it "should have one slot for an image" do
      @doc.at_css('div.tgs-topStories div.tgs-storyDisplay').should be_true
    end
    
    it "should display text for each header" do
      @doc.css('div.tgs-storyItems ul li a').each do |header|
        header.text.gsub(header.css('span').text,"").delete("^a-zA-Z").length.should > 1
      end
    end
    
    it "should display text for each preview blurb" do
      @doc.css('div.tgs-storyItems ul li a span').each do |preview|
        preview.text.delete("^a-zA-Z").length.should > 1
      end
    end

    it "should contain links that only return a 200", :spam => true do
      check_links_200('div.tgs-storyItems')
    end
  
    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.tgs-storyItems')
    end

    it "should display text in the header" do
      header_text = 0
      @doc.css('div.tgs-storyItems ul li a').each do |header|
        if header.text.gsub(header.css('span').text,"").delete("^a-zA-Z").length < 1
          header_text = header_text + 1
        end
      end
      header_text < @doc.css('div.tgs-storyItems ul li a').count
    end
    
    it "should display an image", :smoke => true do
      @doc.at_css("div.tgs-storyDisplay img[@src*='http']").should be_true
    end

    it "should link to content in each of the three slots" do
      @doc.css("div.tgs-storyItems ul li a[@href*='http']").count.should == 3
    end
    
    it "should link to content in the image slot", :smoke => true do
      @doc.at_css("div.tgs-storyDisplay a[@href*='http']").should be_true
    end
    
    it "should link to content in the three slots" do
      @doc.css("div.tgs-storyItems ul li a[@href*='http']").count.should > 0
    end
    
    it "should have at least one <a> tag", :smoke => true do
      @doc.css('div.tgs-storyItems a').count.should > 0
    end
    
    it "should have at least one <img> tag", :smoke => true do
      @doc.css('div.tgs-topStories img').count.should > 0
    end
    
  end
end