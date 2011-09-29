module Ads

  def ads_check_richmedia
    @doc.css('div#sugarad-richmedia').count.should == 1
  end
  
  def ads_check_728x90
    @doc.css('div#sugarad-728x90').count.should == 1
  end
  
  def ads_check_300x250
    @doc.css('div#sugarad-300x250').count.should == 1
  end
  
  def ads_check_featured
    @doc.css('div#sugarad-featured').count.should == 1
  end
  
  def ads_check_side300x250
    @doc.css('div#sugarad-side300x250').count.should == 1
  end
  
  def ads_check_s728x90
    @doc.css('div#sugarad-s728x90').count.should == 1
  end
  
  def ads_check_side300x250_article
    @doc.css('div.grid_16 div#sugarad-side300x250').count.should == 1
  end
  
  def ads_on_tech_page
    it "should have a div on the page for the richmedia ad", :stg => true do
      ads_check_richmedia
    end
    
    it "should have a div on the page for the 728x90 ad", :stg => true do
      ads_check_728x90
    end
    
    it "should have a div on the page for the 300x250 ad", :stg => true do
      ads_check_300x250
    end
    
    it "should have a div on the page for featured ad", :stg => true do
      ads_check_featured
    end
    
    it "should have a div on the page for the side300x250 ad", :stg => true do
      ads_check_side300x250
    end
    
    it "should have a div on the page for the s728x90 ad", :stg => true do
      ads_check_s728x90
    end
  end #end ads_on_tech_page
  
  def ads_on_v2_article
    it "should have a div on the page for the richmedia ad", :stg => true do
      ads_check_richmedia
    end
    
    it "should have a div on the page for the 728x90 ad", :stg => true do
      ads_check_728x90
    end
    
    it "should have a div on the page for the 300x250 ad", :stg => true do
      ads_check_300x250
    end
    
    it "should have a div on the page for featured ad", :stg => true do
      ads_check_featured
    end
    
    it "should have a div on the page for the side300x250 ad", :stg => true do
      ads_check_side300x250
    end
    
    it "should have the div for the side300x250 ad inside the grid_16 div", :stg => true do
      ads_check_side300x250_article
    end
    
    it "should have a div on the page for the s728x90 ad", :stg => true do
      ads_check_s728x90
    end
  end #end ads_on_v2_article
end #end module