module Assert

  #Check API call returns 200 and is not blank
  def check_200_and_not_blank(response, data, url)
    response.code.should eql(200)
    data.length.should > 0
  end
  
  #Check that a specific key exists for all articles returned
  def check_key_exists(response, data, url, key)
    data.each do |article|
      article.has_key?(key).should be_true
    end
  end
  
  #Check that a speficic key within another key exists for all articles returned
  def check_key_within_key_exists(response, data, url, top_key, inner_key)
    data.each do |article|
      article[top_key].has_key?(inner_key).should be_true
    end
  end
  
  #Check key within a key's index exists
  def check_key_within_key_index_exists(response, data, url, top_key, inner_key)
    data.each do |article|
      article[top_key][0].has_key?(inner_key).should be_true
    end
  end
  
  #Check that the value to a key within a key exists
  def check_key_within_key_value_exists(response, data, url, top_key, inner_key) 
    data.each do |article|
      article[top_key].each do |article_key|
        article_key[inner_key].should_not be_nil
        article_key[inner_key].length.should > 0
      end
    end
  end
  
  #Check that the value to a specific key is not nil and it's length is > 0 for all articles returned
  def check_key_value_exists(response, data, url, key)
    data.each do |article|
      article[key].should_not be_nil
      article[key].to_s.length.should > 0
    end
  end
  
  #Check that a specific number of articles were returned
  def article_count(response, data, url, count)
    data.count.should == count.to_i
  end
  
  #Check that a specific key equals a specific value for all articles
  def check_key_eql_a_value(response, data, url, key, value)
    data.each do |article|
      article[key].should_not be_nil
      article[key].should == value
    end
  end
  
  #Check the all articles returned are sorted by publish date, newest first
  def check_sorted_by_publish_date(response, data, url)
    
    publish_dates = []
    
    data.each do |article|
      i = Time.parse(article['publish_date']).to_i
      publish_dates << Time.new(i)
    end
    
    publish_dates.each_index do |d|      
      if d != 0
        (publish_dates[d] <= publish_dates[d-1]).should be_true
      end
    end
  end
  
  #Check the value of a key within a key for all articles
  def check_key_within_key_value(response, data, url, top_key, inner_key, value)
  
    slug_tech = false

    data.each do |article|
      article[top_key].each do |slug_value|
        if slug_value[inner_key] == value
          slug_tech = true
        end
      end
    end 
    slug_tech.should be_true
  end
  
end