module VertNav
  
  require 'link_checker'
  include LinkChecker
  
  def widget_vert_nav_smoke
    it "should be on the page only once", :code => true do
      @doc.css('div.vn-container').count.should == 1
    end
  end
  
  def widget_vert_nav(category, tag)
       
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.vn-container').should be_true
    end
    
    widget_vert_nav_smoke
    
    it "should display all components", :code => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      if tag == 'lifestyle'
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 1
      else
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 3
      end
    end  

    it "should display for the appropriate category and tag combination", :test => true do
      @doc.at_css('div.vn-container li.vn-categoryItem a').attribute('href').text.match("/#{category}/#{tag}").should be_true
    end

    it "should not have any broken links"" do" do
      check_for_broken_links('div.vn-container')
    end
  
    it "should not have any broken images" do
      check_for_broken_images('div.vn-container')
    end
  end
  
end