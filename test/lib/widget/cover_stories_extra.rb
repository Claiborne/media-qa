module CoverStoriesExtra
  
  require 'fe_checker'
  include FeChecker

  def widget_cover_stories_extra_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.extra-coverStories').count.should == 1
    end
  end
  
  def widget_cover_stories_extra
    
    widget_cover_stories_extra_smoke
     
    it "should not be missing from the page", :smoke => true do
       @doc.css('div.extra-coverStories').should be_true
    end
     
    it "should display text", :smoke => true do
       check_display_text('div.extra-coverStories')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.extra-coverStories')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('div.extra-coverStories')
    end

    it "should contain four slots for four cover stories", :smoke => true do
      @doc.css('div.extra-coverStories div.extra-storyItem').count.should == 4
    end
    
    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.extra-coverStories')
    end

    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.extra-coverStories')
    end

    it "should have one image per slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('img').count.should == 1
      end
    end
    
    it "should have at least one link per slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('a').count.should > 0
      end
    end
    
    it "should have at least one <a> tag", :smoke => true do
      @doc.css('div.extra-coverStories a').count.should > 0
    end
    
    it "should have at least one <img> tag", :smoke => true do
      @doc.css('div.extra-coverStories img').count.should > 0
    end

    it "should display text", :smoke => true do
      @doc.css('div.extra-coverStories').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should display text in each slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.text.delete("^a-zA-Z").length.should > 0
      end
    end

  end
end