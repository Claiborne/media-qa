module DiscoverMore
#spec file requires Nokogiri, open-uri, rspec, and rest_client
  
  def widget_discover_more_check_not_missing(doc)
    doc.at_css('div.slider-holder div.slider').should be_true
  end
  
  def widget_discover_more_check_title(doc)
    doc.css('div.slider-holder span.subHeaderSection').text.delete("^a-zA-Z").length.should be > 1
  end
  
  def widget_discover_more_check_img_not_400_or_500(doc)
    img_src = doc.at_css('div.slider-holder div.slider img').attribute('src')
    response = rest_client_open img_src.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  

  def widget_discover_more_check_next_and_prev_links_not_400_or_500(doc)
    next_slider = doc.at_css('div.slider-holder div.slider a.next').attribute('href')
    prev_slider = doc.at_css('div.slider-holder div.slider a.prev').attribute('href')
    response = rest_client_open next_slider.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
    response = rest_client_open prev_slider.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end

  
  def widget_discover_more_check_article_links(doc)
    doc.at_css('div.slider-holder div.description ul.list a').text.delete("^a-zA-Z").length.should be > 1
  end
  
  def widget_discover_more_check_article_links_not_400_or_500(doc)
    first_article_link = doc.at_css('div.slider-holder div.description ul.list a').attribute('href')
    response = rest_client_open first_article_link.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more_check_news_and_updates_link_not_400_or_500(doc)
    news_and_updates = doc.at_css('div.slider-holder div.description strong.link a').attribute('href')
    response = rest_client_open news_and_updates.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more
    
    it "should not be missing from the page", :code => true do
      widget_discover_more_check_not_missing(@doc)
    end
    
    it "should display a title" do
      widget_discover_more_check_title(@doc)
    end
    
    it "should display an non-broken image" do
      widget_discover_more_check_img_not_400_or_500(@doc)
    end
    
    it "should display text links to articles" do
      widget_discover_more_check_article_links(@doc)
    end
    
    it "should display text links to articles that are not 400 or 500" do
      widget_discover_more_check_article_links_not_400_or_500(@doc)
    end
    
    it "should link to a category or topic page that is not 400 or 500" do
      widget_discover_more_check_news_and_updates_link_not_400_or_500(@doc)
    end  
  end
  
  def wiget_discover_more_expanded
    
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.topicTiles').should be_true
    end
    
    it "should contain the same number of links and images as are tech tag pages", :code => true do
      return_tech_nav.count.should == @doc.css('div.topicTiles a').count
      return_tech_nav.count.should == @doc.css('div.topicTiles a img').count
    end
    
    it "should contain links to each of the tag pages", :code => true do
      return_tech_nav.each do |nav|
        @doc.css('div.topicTiles a').to_s.match(/www.ign.com\/tech\/#{nav}/).should be_true
      end
    end
    
    it "should contain links that only return a response code of 200" do
      @doc.css('div.topicTiles a').each do |a|
        response = rest_client_open a.attribute('href').to_s
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
        response.code.should_not eql(/3\d\d/)
        response.code.should eql(200)
      end
    end
    
    it "should not contain any broken links" do
      @doc.css('div.topicTiles a img').each do |img|
        response = rest_client_open img.attribute('src').to_s
        response.code.should_not eql(/4\d\d/)
        response.code.should_not eql(/5\d\d/)
        response.code.should eql(200)
      end
    end

  end  
end