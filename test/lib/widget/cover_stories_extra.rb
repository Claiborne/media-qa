module CoverStoriesExtra

  
  def widget_cover_stories_extra

    it "should not be missing from the page", :stg => true, :code => true do
      @doc.css('div.extra-coverStories').should be_true
    end

    it "should contain four slots for four cover stories", :stg => true do
      @doc.css('div.extra-coverStories div.extra-storyItem').count.should == 4
    end
    
    it "should not have any broken images", :stg => true do
      @doc.css('div.extra-coverStories img').each do |img|
        img_link = img.attribute('src').to_s
        if img_link.match(/http/)
          response = RestClient.get img_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = RestClient.get @page.gsub(/[a-zA-Z0-9_]*\z/,"")+img_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end

    it "should not have any broken links", :stg => true do
      @doc.css('div.extra-coverStories a').each do |a|
        a_link = a.attribute('href').to_s
        if a_link.match(/http/)
          response = RestClient.get a_link
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        else
          response = RestClient.get @page.gsub(/[a-zA-Z0-9_]*\z/,"")+a_link.gsub(" ","%20")
          response.code.should_not eql(/4\d\d/)
          response.code.should_not eql(/5\d\d/)
        end
      end
    end

    it "should display paragraph text for each cover story slot", :stg => true do
      @doc.css('div.extra-coverStories div.extra-storyItem p').each do |paragraph|  
        paragraph.text.delete("^a-zA-Z").length.should > 1
      end
    end

    it "should not have more than one image per slot", :stg => true do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('img').count.should < 2
      end
    end
    
    it "should have at least one link per slot", :stg => true do
      @doc.css('div.extra-coverStories div.extra-storyItem').each do |slot|
        slot.css('a').count.should > 1
      end
    end
    
    it "should have at least one <a> tag", :stg => true do
      @doc.css('div.extra-coverStories a').count.should > 1
    end
    
    it "should have at least one <img> tag", :stg => true do
      puts @doc.css('div.extra-coverStories img').count.should > 1
    end

    it "should display text", :stg => true do
      puts ""
      puts @doc.css('div.extra-coverStories').text.delete("^a-zA-Z")
      puts""
      @doc.css('div.extra-coverStories').text.delete("^a-zA-Z").length.should > 1
    end

  end
end