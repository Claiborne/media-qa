module OpenPage

def nokogiri_open(page)
  stitial_count = 0 
  begin
    nok_doc = Nokogiri::HTML(RestClient.get(page))
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s )
  end#end Exception
  return nok_doc
end#end def

def nokogiri_not_301_home_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_home_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  return Nokogiri::HTML(rest_doc)
end

def nokogiri_not_301_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  return Nokogiri::HTML(rest_doc)
end

def rest_client_open(page)
  stitial_count = 0
  begin
    rest_doc = RestClient.get(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  return rest_doc
end

def rest_client_not_301_home_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_home_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  return rest_doc
end

def rest_client_not_301_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_helper(page)
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s)
  end#end Exception
  return rest_doc
end


def rest_client_not_301_home_helper(page)
  RestClient.get(page){ |response, request, result, &block|
    if ["300","301","302","303","304","307"].include? response.code.to_s
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