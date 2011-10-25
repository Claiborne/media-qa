module CoverStoriesExtra

  
  def widget_cover_stories_extra

    it "should not be missing from the page", :code => true do
      @doc.css('div.extra-coverStories').should be_true
    end
    
    it "should be on the page only once", :code => true do
      @doc.css('div.extra-coverStories').count.should == 1
    end

    it "should contain four slots for four cover stories" do
      @doc.css('div.extra-coverStories div.extra-storyItem').count.should == 4
    end
    
    it "should not have any broken images" do
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

    it "should not have any broken links" do
      @doc.css('div.extra-coverStories a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = rest_client_open a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = rest_client_open @page.gsub(/[a-zA-Z0-9-]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
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
    
    it "should have at least one <a> tag" do
      @doc.css('div.extra-coverStories a').count.should > 0
    end
    
    it "should have at least one <img> tag" do
      @doc.css('div.extra-coverStories img').count.should > 0
    end

    it "should display text" do
      @doc.css('div.extra-coverStories').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should display text in each slot" do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.text.delete("^a-zA-Z").length.should > 0
      end
    end

  end
end