module Assert

#####################
#Begin v2
#####################

  def 200_and_not_blank(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.length.should > 0
  end
  
  def articles_with_a_slug(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    data = JSON.parse(response.body)  
    data.each do |article|
      article['slug'].should_not be_nil
      article['slug'].length.should > 0
    end
  end
  
  def ten_articles(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    data = JSON.parse(response.body) 
    data.count.should == 10
  end
  
  def articles_with_a_post_type_of_article(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    data = JSON.parse(response.body)  
    data.each do |article|
      article['post_type'].should_not be_nil
      article['post_type'].should == 'article'
    end
  end
  
  def articles_sorted_by_publish_date(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    data = JSON.parse(response.body) 
    
    publish_dates = []
    
    data.each do |article|
      i = Time.parse(article['created_at']).to_i
      publish_dates << Time.new(i)
    end
    
    publish_dates.each_index do |d|      
      if d != 0
        (publish_dates[d] >= publish_dates[d-1]).should be_true
      end
    end
  end
  
  def articles_in_a_published_state_by_default(url)
    response = RestClient.get "http://#{@config.options['baseurl']}#{url}"
    data = JSON.parse(response.body)  
    data.each do |article|
      article['state'].should_not be_nil
      article['state'].should == 'published'     
    end
  end
end