module EvoHeader
  
  def return_evo_header_nav_links
    [ "http://www.ign.com",
      "http://xbox360.ign.com",
      "http://ps3.ign.com",
      "/wii-u",
      "http://pc.ign.com",
      "http://vita.ign.com",
      "http://ds.ign.com",
      "http://wireless.ign.com",
      "/tech",
      "http://movies.ign.com",
      "http://tv.ign.com",
      "http://comics.ign.com",
      "/index/reviews.html",
      "/wikis",
      "/index/upcoming.html",
      "/index/features.html",
      "/videos",
      "/boards",
      "http://stars.ign.com",
      "/blogs",
      "/index/podcasts.html"]
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
    
    # user-bar assertions
    
    it "should display the user-bar once", :smoke => true do
      @doc.css('div#ignHeader div#ignHeader-userBar').count.should == 1
    end
    
    # user-tools (logged-out) assertions
    
    it "should display the user-tools once", :smoke => true do
       @doc.css('div#ignHeader div.userTools').count.should == 1
    end
    
    it "should link to s.ign.com/login in the user-tools", :smoke => true do
      @doc.at_css("div#ignHeader div.userTools a[href*='s.ign.com/login']")
    end
    
    it "should link to s.ign.com/register in the user-tools", :smoke => true do
      @doc.at_css("div#ignHeader div.userTools a[href*='s.ign.com/resgister']")
    end
    
    # site nav assertions
    
    it "should display the site nav once", :smoke => true do
       @doc.css('div#ignHeader div#ignHeader-navigation').count.should == 1
    end
    
    return_evo_header_nav_links.each do |nav_link|
      it "should link to #{nav_link} in the site nav", :ee => true do
        @doc.at_css("div#ignHeader div#ignHeader-navigation li a[href='#{nav_link}']").should be_true
      end
      
      if nav_link != "http://www.ign.com"
        it "should visually display the #{nav_link} link", :ee => true do
          @doc.at_css("div#ignHeader div#ignHeader-navigation li a[href='#{nav_link}']").text.delete('^a-zA-Z0-9').length.should > 0
        end
      end
    end
    
  end
end