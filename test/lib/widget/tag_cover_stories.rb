module TagCoverStories
  
  def widget_tag_cover_stories
    
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.tgs-topStories div.tgs-storyItems').should be_true
    end
    
    it "should be on the page only once", :code => true do
      @doc.css('div.tgs-topStories div.tgs-storyItems').count.should == 1
    end

    it "should have three slots for three stories" do
      @doc.css('div.tgs-topStories div.tgs-storyItems ul li').count.should == 3
    end
    
    it "should have one slot for an image" do
      @doc.at_css('div.tgs-topStories div.tgs-storyDisplay').should be_true
    end
    
    it "should display text for each header" do
      @doc.css('div.tgs-storyItems ul li a').each do |header|
        header.text.gsub(header.css('span').text,"").delete("^a-zA-Z").length.should > 1
      end
    end
    
    it "should display text for each preview blurb" do
      @doc.css('div.tgs-storyItems ul li a span').each do |preview|
        preview.text.delete("^a-zA-Z").length.should > 1
      end
    end

    it "should not have any broken links" do
      @doc.css('div.tgs-storyItems a').each do |a|
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
  
    it "should not have any broken images" do
      @doc.css('div.tgs-storyItems img').each do |img|
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

    it "should display text in the header" do
      header_text = 0
      @doc.css('div.tgs-storyItems ul li a').each do |header|
        if header.text.gsub(header.css('span').text,"").delete("^a-zA-Z").length < 1
          header_text = header_text + 1
        end
      end
      header_text < @doc.css('div.tgs-storyItems ul li a').count
    end
    
    it "should display an image" do
      @doc.at_css("div.tgs-storyDisplay img[@src*='http']").should be_true
    end

    it "should link to content in each of the three slots" do
      @doc.css("div.tgs-storyItems ul li a[@href*='http']").count.should == 3
    end
    
    it "should link to content in the image slot" do
      @doc.at_css("div.tgs-storyDisplay a[@href*='http']").should be_true
    end
    
    it "should link to content in the three slots" do
      @doc.css("div.tgs-storyItems ul li a[@href*='http']").count.should > 0
    end
    
    it "should have at least one <a> tag" do
      @doc.css('div.tgs-storyItems a').count.should > 0
    end
    
    it "should have at least one <img> tag" do
      @doc.css('div.tgs-topStories img').count.should > 0
    end
    
  end
end