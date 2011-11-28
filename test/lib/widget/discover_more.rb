module DiscoverMore
#spec file requires Nokogiri, open-uri, rspec, and rest_client

  require 'fe_checker'
  include FeChecker
  
  def widget_discover_more_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.slider-holder div.slider').count.should == 1
    end
  end
  
  def wiget_discover_more_expanded_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.topicTiles').count.should == 1
    end
  end
  
  def widget_discover_more
    
    widget_discover_more_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.slider-holder div.slider').should be_true
    end
    
    it "should display text", :smoke => true do
       check_display_text('div.slider-holder')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.slider-holder')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('div.slider-holder')
    end
    
    it "should display a title" do
      @doc.css('div.slider-holder span.subHeaderSection').text.delete("^a-zA-Z").length.should be > 0
    end
    
    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.slider-holder')
    end
    
    it "should not display broken images", :spam => true do
      check_for_broken_images('div.slider-holder')
    end
    
    it "should display text links to articles" do
      @doc.at_css('div.slider-holder div.description ul.list a').text.delete("^a-zA-Z").length.should be > 0
    end
  
  end
  
  def wiget_discover_more_expanded
    
    wiget_discover_more_expanded_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.topicTiles').should be_true
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.topicTiles')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('div.topicTiles')
    end
    
    it "should contain the same number of links and images as are tech tag pages", :smoke => true do
      return_tech_nav.count.should == @doc.css('div.topicTiles a').count
      return_tech_nav.count.should == @doc.css('div.topicTiles a img').count
    end
    
    it "should contain links to each of the tag pages", :smoke => true do
      return_tech_nav.each do |nav|
        @doc.css('div.topicTiles a').to_s.match(/www.ign.com\/tech\/#{nav}/).should be_true
      end
    end
    
    it "should not display broken images", :spam => true do
      check_for_broken_images('div.topicTiles')
    end
    
    it "should contain links that only return a 200", :spam => true do
      check_links_not_301('div.topicTiles')
    end
    
  end  
  
end