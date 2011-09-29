module VertNav
  
  def widget_vert_nav(category, tag)
    
    it "should not be missing from the page", :stg => true do
      @doc.at_css('div.vn-container ul li').should be_true
    end
    
    it "should display all components", :stg => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      @doc.css('div.vn-container ul li.vn-navItem a').count.should > 2
      
    end  

    it "should display for the appropriate category and tag combination", :stg => true do
      @doc.at_css('div.vn-container li.vn-categoryItem a').attribute('href').text.should eql("/#{category}/#{tag}")
    end
    
    it "should not have any nav item http links that return 400 or 500", :stg => true do
      @doc.css("div.vn-container a[@href*='http']").each do |a|
        response = RestClient.get a.attribute('href').text
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end
    
  end
end