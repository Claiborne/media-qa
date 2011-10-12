module VertNav
  
  def widget_vert_nav(category, tag)
    
    it "should not be missing from the page", :stg => true, :code => true do
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

    it "should not have any broken links", :stg => true do
      @doc.css('div.vn-container a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = RestClient.get a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = RestClient.get @page.gsub(/\/[a-zA-Z0-9_]*\/[a-zA-Z0-9_]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end
    
    it "should not have any broken images", :stg => true do
      @doc.css("div.vn-container img[href='http']").each do |img|
        img_link = img.attribute('src').to_s
        response = RestClient.get img_link
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end
    
  end
end