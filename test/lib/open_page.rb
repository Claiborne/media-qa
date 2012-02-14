module OpenPage

def nokogiri_open(page)
  stitial_count = 0 
  begin
    nok_doc = Nokogiri::HTML(RestClient.get(page))
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s )
  end#end Exception
  while nok_doc.at_css('div#disable')
    begin
      nok_doc = Nokogiri::HTML(RestClient.get(page))
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s )
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise Exception.new("An endless stitial loop on #{page} prevented this test case from running")
    elsif stitial_count > 2
      begin
        nok_doc = Nokogiri::HTML(RestClient.get(page+"?special=noads"))
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return nok_doc
end#end def

def rest_client_open(page)
  stitial_count = 0
  begin
    rest_doc = RestClient.get(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = RestClient.get(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = RestClient.get(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

def rest_client_not_301_home_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_home_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_301_home_helper(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_301_home_helper(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

def rest_client_not_301_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_301_helper(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_301_helper(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end


def rest_client_not_301_home_helper(page)
  RestClient.get(page){ |response, request, result, &block|
    #if ["300","301","302","303","304","307"].include? response.code.to_s
    if ["302"].include? response.code.to_s
      if ["/","http://www.ign.com","http://www.ign.com/"].include? response.headers[:location].to_s
        raise Exception.new("#{page} did not return a 200 but instead a #{response.code} to the homepage")
      else
        response.return!(request, result, &block)
      end
    else
      response.return!(request, result, &block)
    end }
end

def rest_client_not_301_helper(page)
  RestClient.get(page){ |response, request, result, &block|
     if ["300","301","302","303","304","307"].include? response.code.to_s
      if ["404","500","401","403","406","408","501","502","503","504","505","412","414","410","409"].include? response.follow_redirection(request, result, &block).code
        response.follow_redirection(request, result, &block)
      else
        raise Exception.new("#{page} did not return a 200 but instead a #{response.code} to #{response.headers[:location]}")
      end
    else
      response.return!(request, result, &block)
    end }
end

end#end module