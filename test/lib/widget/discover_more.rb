module DiscoverMore
#spec file requires Nokogiri, open-uri, rspec, and rest_client
  
  def widget_discover_more_check_not_missing(doc)
    doc.at_css('div.slider-holder div.subHeaderContainer').should be_true
  end
  
  def widget_discover_more_check_title(doc)
    doc.css('div.slider-holder span.subHeader').text.strip.length.should be > 5
  end
  
  def widget_discover_more_check_img_not_400_or_500(doc)
    img_src = doc.at_css('div.slider-holder div.slider img').attribute('src')
    response = RestClient.get img_src.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more_check_next_and_prev_links_not_400_or_500(doc)
    next_slider = doc.at_css('div.slider-holder div.slider a.next').attribute('href')
    prev_slider = doc.at_css('div.slider-holder div.slider a.prev').attribute('href')
    response = RestClient.get next_slider.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
    response = RestClient.get prev_slider.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more_check_article_links(doc)
    doc.at_css('div.slider-holder div.description ul.list a').text.strip.length.should be > 5
  end
  
  def widget_discover_more_check_article_links_not_400_or_500(doc)
    first_article_link = doc.at_css('div.slider-holder div.description ul.list a').attribute('href')
    response = RestClient.get first_article_link.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more_check_news_and_updates_link_not_400_or_500(doc)
    news_and_updates = doc.at_css('div.slider-holder div.description strong.link a').attribute('href')
    response = RestClient.get news_and_updates.to_s
    response.code.should_not eql(/4\d\d/)
    response.code.should_not eql(/5\d\d/)
  end
  
  def widget_discover_more
    
    it "should not be missing from the page", :stg => true do
      widget_discover_more_check_not_missing(@doc)
    end
    
    it "should display a title", :stg => true do
      widget_discover_more_check_title(@doc)
    end
    
    it "should display an non-broken image", :stg => true do
      widget_discover_more_check_img_not_400_or_500(@doc)
    end
    
    it "should have next and prev links that are not 400 or 500", :stg => true do
      widget_discover_more_check_next_and_prev_links_not_400_or_500(@doc)
    end
    
    it "should display text links to articles", :stg => true do
      widget_discover_more_check_article_links(@doc)
    end
    
    it "should display text links to articles that are not 400 or 500", :stg => true do
      widget_discover_more_check_article_links_not_400_or_500(@doc)
    end
    
    it "should link to a category or topic page that is not 400 or 500", :stg => true do
      widget_discover_more_check_news_and_updates_link_not_400_or_500(@doc)
    end  
  end
  
end