module VertNav
  
  require 'link_checker'
  include LinkChecker
  
  def widget_vert_nav_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.vn-container').count.should == 1
    end
  end
  
  def widget_vert_nav(category, tag)
    
    widget_vert_nav_smoke
       
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.vn-container').should be_true
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

    it "should not have any broken links"" do", :spam => true do
      check_for_broken_links('div.vn-container')
    end
  
    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.vn-container')
    end
  end
  
end