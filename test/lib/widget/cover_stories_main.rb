module CoverStoriesMain
  
  require 'link_checker'
  include LinkChecker
  
  def widget_cover_stories_main_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.cat-coverStories').count.should == 1
    end
  end
  
  def widget_cover_stories_main
    
    widget_cover_stories_main_smoke

    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.cat-coverStories').should be_true
    end

    it "should contain three slots for three cover stories" do
      @doc.css('div.cat-coverStories a').count.should == 3
    end

    it "should have an img for each cover story slot" do
      @doc.css('div.cat-coverStories a').each do |a|
        a.attribute('style').to_s.match(/background-image:url/).should be_true
        a.attribute('style').to_s.match(/http/).should be_true
      end
    end

    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.cat-coverStories')
    end

    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.cat-coverStories')
    end
    
    it "should have three headline spans" do
      @doc.css('div.cat-coverStories span.lcs-headline').count.should == 3
    end

    it "should display a headline for each cover story" do
      @doc.css('div.cat-coverStories span.lcs-headline').each do |headline|
        headline.text.delete("^a-zA-Z").length.should > 0
      end
    end
    
    it "should display text", :smoke => true do
      should_display_text('div.cat-coverStories')
    end

    it "should display headlines" do
      error_rate = 0
      @doc.css('div.cat-coverStories span.lcs-headline').each do |headline|
        if headline.text.delete("^a-zA-Z").length < 1
          error_rate = error_rate + 1
        end
      end
      error_rate.should < 3
    end

    it "should have at least one <a> tag", :smoke => true do
      @doc.css('div.cat-coverStories a').count.should > 0
    end

  end
end