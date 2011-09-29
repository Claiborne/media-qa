module CoverStoriesMain
  
  def widget_cover_stories_main

    it "should not be missing from the page", :stg => true do
      @doc.at_css('div.cat-coverStories').should be_true
    end
    
    it "should contain three slots for three cover stories", :stg => true do
      @doc.css('div.cat-coverStories div.prime').count.should == 1
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary']").count.should == 1
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary']").count.should == 1
    end
    
    it "should have an <a> tag for each cover story slot", :stg => true do
      @doc.css('div.cat-coverStories div.prime > a').count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary'] > a").count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary'] > a").count.should > 0
    end
    
    it "should have an <img> tag for each cover story slot", :stg => true do
      @doc.css('div.cat-coverStories div.prime > a img').count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary'] > a img").count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary'] > a img").count.should > 0
    end

    it "should not have broken images", :stg => true do
      @doc.css('div.cat-coverStories img').each do |img|
        img_link = img.attribute('src').to_s
        img_link.match(/http/).should be_true
        response = RestClient.get img_link
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end
    end
  
    it "should not have any broken http links", :stg => true do
      @doc.css("div.cat-coverStories a[@href*='http']").each do |link|
        response = RestClient.get link.attribute('href').to_s
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
      end  
    end

    it "should display a title for each cover story slot", :stg => true do
      @doc.css('div.cat-coverStories div.lcs-headline').each do |headline|
        headline.text.strip.length.should > 0
      end
    end
    
  end
end