module VertNav
  
  def widget_vert_nav(category, tag)
       
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.vn-container ul li').should be_true
    end
    
    it "should display all components", :code => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      if tag == 'lifestyle'
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 1
      else
        @doc.css('div.vn-container ul li.vn-navItem a').count.should > 3
      end
    end  

    it "should display for the appropriate category and tag combination" do
      @doc.at_css('div.vn-container li.vn-categoryItem a').attribute('href').text.should eql("/#{category}/#{tag}")
    end

    it "should not have any broken links" do
      @doc.css('div.vn-container a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = rest_client_open a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = rest_client_open @page.gsub(/\/[a-zA-Z0-9-]*\/[a-zA-Z0-9-]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end
  
    it "should not have any broken images" do
      @doc.css("div.vn-container img[href='http']").each do |img|
        img_link = img.attribute('src').to_s
        response = rest_client_open img_link
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end

  end
end