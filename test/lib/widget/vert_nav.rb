module VertNav
  
  require 'fe_checker'
  include FeChecker
  
  def widget_vert_nav_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.vn-container').should be_true
    end
  end
  
  def widget_vert_nav(category, tag)
    
    widget_vert_nav_smoke
       
    it "should be on the page once", :smoke => true do
      @doc.css('div.vn-container').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.vn-container')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.vn-container')
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img('div.vn-container')
    end
    
    it "should display all components", :smoke => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      if tag == 'lifestyle'
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 1
      else
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 4
      end
    end  

    it "should display for the appropriate category and tag combination" do
      @doc.at_css('div.vn-container li.vn-categoryItem a').attribute('href').text.match("/#{category}/#{tag}").should be_true
    end

    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.vn-container')
    end
  
    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.vn-container')
    end
  end
  
end