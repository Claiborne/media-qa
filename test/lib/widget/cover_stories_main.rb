module CoverStoriesMain
  
  def widget_cover_stories_main

    it "should not be missing from the page", :code => true do
      @doc.at_css('div.cat-coverStories').should be_true
    end

    it "should contain three slots for three cover stories" do
      @doc.css('div.cat-coverStories div.prime').count.should == 1
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary']").count.should == 1
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary']").count.should == 1
    end
    
    it "should have an <a> tag for each cover story slot" do
      @doc.css('div.cat-coverStories div.prime > a').count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary'] > a").count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary'] > a").count.should > 0
    end

    it "should have an <img> tag for each cover story slot" do
      @doc.css('div.cat-coverStories div.prime > a img').count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 secondary'] > a img").count.should > 0
      @doc.css("div.cat-coverStories div[@class='grid_6 omega secondary'] > a img").count.should > 0
    end

    it "should not have any broken images" do
      @doc.css('div.cat-coverStories img').each do |img|
        img_link = img.attribute('src').to_s
        if img_link.match(/http/)
          response = rest_client_open img_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = rest_client_open @page.gsub(/[a-zA-Z0-9_]*\z/,"")+img_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end

    it "should not have any broken links" do
      @doc.css('div.cat-coverStories a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = rest_client_open a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = rest_client_open @page.gsub(/[a-zA-Z0-9_]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end

    it "should display a headline for each cover story slot" do
      @doc.css('div.cat-coverStories div.lcs-headline').each do |headline|
        headline.text.delete("^a-zA-Z").length.should > 1
      end
    end

    it "should display headlines" do
      error_rate = 0
      @doc.css('div.cat-coverStories div.lcs-headline').each do |headline|
        if headline.text.delete("^a-zA-Z").length < 1
          error_rate = error_rate + 1
        end
      end
      error_rate.should < @doc.css('div.cat-coverStories div.lcs-headline').count
    end

    it "should have at least one <a> tag" do
      @doc.css('div.cat-coverStories a').count.should > 1
    end
    
    it "should have at least one <img> tag" do
      puts @doc.css('div.cat-coverStories img').count.should > 1
    end

  end
end