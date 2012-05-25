module Assert
  
  #Check API response is 200
  def check_200(response)
    response.code.should eql(200)
  end
  
  #Check API does not return a blank json
  def check_not_blank(data)
    data.length.should > 0
    data.to_s.delete("^a-zA-Z0-9").length.should > 0
  end
  
  #Check API json returns
  def check_indices(data, num)
    data.length.should == num
  end
  
  #          BELOW ARE DEPRECATED METHODS AND SHOULD NOT BE USED          #
  
  #Check an API body response returns a specific key with a non nil and non blank value
  def check_key(response, data, key)
    data[key.to_s].should_not be_nil
    data[key.to_s].to_s.length.should > 0
  end
  
  #Check an API body response returns a specific key with a specific value
  def check_key_equals(response, data, key, val)
    data[key].should == val
  end
  
  #Check that a specific key exists for all articles returned
  def check_key_exists_for_all(response, data, key)
    data.each do |article|
      article.has_key?(key).should be_true
    end
  end
  
  #Check that the value to a specific key's value is not nil and it's length is > 0 for all articles returned
  def check_key_value_exists_for_all(response, data, key)
    data.each do |article|
      article[key].should_not be_nil
      article[key].to_s.length.should > 0
    end
  end
  
  #Check that a speficic key within another key exists for all articles returned
  #Example: {top_key: {inner_key: value} }
  def check_key_within_key_exists_for_all(response, data, top_key, inner_key)
    data.each do |article|
      article[top_key].has_key?(inner_key).should be_true
    end
  end
  
  #Check that the value to a key exists for all articles. This key-value pair is within an hash, and the hash is the value of a higher key
  #Example: {top_key: {inner_key: value} }
  def check_value_of_key_within_hash_exists_for_all(response, data, top_key, inner_key) 
    data.each do |article|
      article[inner_key].should_not be_nil
      article[inner_key].length.should > 0
    end
  end
  
  #Check that a specific key exists for all articles. This key is within an array, and the array is the value of a higher key
  #Example: {top_key: [ {inner_key: value} ] }
  def check_key_within_array_exists_for_all(response, data, top_key, inner_key)
    data.each do |article|
      article[top_key][0].has_key?(inner_key).should be_true
    end
  end
  
  #Check that the value to a key exists for all articles. This key-value pair is within an array, and the array is the value of a higher key
  #Example: {top_key: [ {inner_key: value} ] }
  def check_value_of_key_within_array_exists_for_all(response, data, top_key, inner_key) 
    data.each do |article|
      article[top_key][0][inner_key].should_not be_nil
      article[top_key][0][inner_key].length.should > 0
    end
  end
  
  #Check that a specific number of articles were returned
  def article_count(response, data, count)
    data.count.should == count.to_i
  end
  
  #Check that a key's value equals a specific value for all articles
  #Example {key: value}
  def check_key_value_equals_for_all(response, data, key, value)
    data.each do |article|
      article[key].should_not be_nil
      article[key].should == value
    end
  end
  
  
  #          BELOW ARE DEPRECATED METHODS FOR V2 ONLY          #
  
  
  #Check the all articles returned are sorted by publish date, newest first
  def check_sorted_by_publish_date(response, data)
    
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
  
  #CHECK CATEGORY or TAG. Check the value of a key within an array for all articles. Useful for array's with multipule of the same keys (like slug).
  #Example {top_key : [ {inner_key: value, other_key: other_value} ] }
  def check_key_value_within_array_contains_for_all(response, data, top_key, inner_key, value)

    data.each do |article|
    slug_tech = false
      article[top_key].each do |slug_value|
        if slug_value[inner_key] == value
          slug_tech = true
        end
      end 
      slug_tech.should be_true
    end 
  end
  
  def check_no_duplicates_by_slug(response, data)
    slug = []
    data.each do |article|
      slug << article['slug']
    end
  slug.count.should eql(slug.uniq.count)
  end
  
end