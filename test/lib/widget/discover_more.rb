module DiscoverMore
#spec file requires Nokogiri, open-uri, rspec, and rest_client
  
  def widget_discover_more_check_not_missing(doc)
    doc.at_css('div.slider-holder div.subHeaderContainer').should be_true
  end
  
  def widget_discover_more_check_title(doc)
    doc.css('div.slider-holder span.subHeader').text.delete("^a-zA-Z").length.should be > 1
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
    
    it "should have next and prev links that are not 400 or 500" do
      widget_discover_more_check_next_and_prev_links_not_400_or_500(@doc)
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
  
end