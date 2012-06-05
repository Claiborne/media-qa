module EvoHeader
  
  def return_evo_header_nav_links
    [ "http://www.ign.com",
      "http://www.ign.com/xbox-360",
      "http://www.ign.com/ps3",
      "http://www.ign.com/wii-u",
      "http://www.ign.com/pc",
      "http://www.ign.com/ps-vita",
      "http://www.ign.com/ds",
      "http://www.ign.com/wireless",
      "http://www.ign.com/tech",
      "http://www.ign.com/movies",
      "http://www.ign.com/tv",
      "http://www.ign.com/comics",
      "http://www.ign.com/games/reviews?filter=latest",
      "http://www.ign.com/wikis",
      "http://www.ign.com/games/upcoming",
      "http://www.ign.com/articles",
      "http://www.ign.com/videos",
      "http://www.ign.com/boards",
      "http://www.ign.com/blogs"
    ]
  end

  require 'fe_checker'
  include FeChecker
  
  def widget_evo_header_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div#ignHeader').should be_true
    end
  end
  
  def widget_evo_header
    
    # general assertions
    
    widget_evo_header_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div#ignHeader').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div#ignHeader')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div#ignHeader')
    end
    
    it "should display the IGN logo" do
      @doc.at_css('div#ignHeader a#ignHeader-logo').should be_true
    end
    
    # user-bar assertions
    
    it "should display the user-bar once", :smoke => true do
      @doc.css('div#ignHeader div#ignHeader-userBar').count.should == 1
    end
    
    it "should display the headerTools once", :smoke => true do
      @doc.css('div#ignHeader div.headerTools').count.should == 1
    end
    
    ["http://my.ign.com/prime/hub","http://my.ign.com"].each do |social_links|
      it "should link to #{social_links}" do
        @doc.at_css("div#ignHeader div.headerTools a[href='#{social_links}']").should be_true
      end
    end
    
    it "should display the search bar" do
       @doc.at_css("div#ignHeader li.profileLink-item form.ignHeader-searchForm").should be_true
    end
    
    # site nav assertions
    
    it "should display the site nav once", :smoke => true do
       @doc.css('div#ignHeader div#ignHeader-navigation').count.should == 1
    end
    
    return_evo_header_nav_links.each do |nav_link|
      it "should link to #{nav_link} in the site nav" do
        @doc.at_css("div#ignHeader div#ignHeader-navigation li a[href='#{nav_link}']").should be_true
      end
      
      if nav_link != "http://www.ign.com"
        it "should visually display the #{nav_link} link" do
          @doc.at_css("div#ignHeader div#ignHeader-navigation li a[href='#{nav_link}']").text.delete('^a-zA-Z0-9').length.should > 0
        end
      end
    end
    
  end
end