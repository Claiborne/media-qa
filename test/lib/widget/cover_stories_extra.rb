module CoverStoriesExtra

  def widget_cover_stories_extra_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.extra-coverStories').count.should == 1
    end
  end
  
  def widget_cover_stories_extra
    
     widget_cover_stories_extra_smoke

    it "should not be missing from the page", :smoke => true do
      @doc.css('div.extra-coverStories').should be_true
    end

    it "should contain four slots for four cover stories", :smoke => true do
      @doc.css('div.extra-coverStories div.extra-storyItem').count.should == 4
    end
    
    it "should not have any broken images", :spam => true do
      @doc.css('div.extra-coverStories img').each do |img|
        img_link = img.attribute('src').to_s
        if img_link.match(/http/)
          response = rest_client_open img_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = rest_client_open @page.gsub(/[a-zA-Z0-9-]*\z/,"")+img_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end

    it "should contain links that only return a response code of 200", :spam => true do
      @doc.css('div.extra-coverStories a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = rest_client_open a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
          response.code.should eql(200)
        else
          response = rest_client_open @page.gsub(/[a-zA-Z0-9-]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
          response.code.should eql(200)
        end
      end
    end

    it "should have one image per slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('img').count.should == 1
      end
    end
    
    it "should have at least one link per slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('a').count.should > 0
      end
    end
    
    it "should have at least one <a> tag", :smoke => true do
      @doc.css('div.extra-coverStories a').count.should > 0
    end
    
    it "should have at least one <img> tag", :smoke => true do
      @doc.css('div.extra-coverStories img').count.should > 0
    end

    it "should display text", :smoke => true do
      @doc.css('div.extra-coverStories').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should display text in each slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.text.delete("^a-zA-Z").length.should > 0
      end
    end

  end
end