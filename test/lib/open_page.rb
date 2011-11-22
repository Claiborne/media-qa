module OpenPage

def nokogiri_open(page)
  stitial_count = 0 
  begin
    nok_doc = Nokogiri::HTML(open(page))
  rescue => e
    raise Exception.new("#{e.message} on "+page.to_s )
  end#end Exception
  while nok_doc.at_css('div#disable')
    begin
      nok_doc = Nokogiri::HTML(open(page))
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s )
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise Exception.new("An endless stitial loop on #{page} prevented this test case from running")
    elsif stitial_count > 2
      begin
        nok_doc = Nokogiri::HTML(open(page+"?special=noads"))
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
    #####################
    raise Exception.new("#{e.message} on "+page.to_s+" "+e.http_body+" "+e.inspect+" "+e.backtrace.to_s)
    #####################
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
    rest_doc = rest_client_not_301_home(page)
  rescue => e
    #####################
    raise Exception.new("#{e.message} on "+page.to_s+" "+e.http_body+" "+e.inspect+" "+e.backtrace.to_s)
    #####################
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_301_home(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_301_home(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

def rest_client_not_310_open(page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_310(page)
  rescue => e
    #####################
    raise Exception.new("#{e.message} on "+page.to_s+" "+e.http_body+" "+e.inspect+" "+e.backtrace.to_s)
    #####################
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_310(page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_310(page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end


def rest_client_not_301_home(page)
  RestClient.get(page){ |response, request, result, &block|
    if response.code == 301
      if ["http://www.ign.com", "http://www.ign.com/"].include? response.headers[:location]
        raise Exception.new("#{page} did not return a 200 but instead a #{response.code} to #{response.headers[:location]}")
      else
        response.return!(request, result, &block)
      end
    else
      response.return!(request, result, &block)
    end }
end

def rest_client_not_310(page)
  RestClient.get(page){ |response, request, result, &block|
    if response.code == 301
      if [/4\d\d/, /5\d\d/].include? response.follow_redirection(request, result, &block).code
        response.follow_redirection(request, result, &block)
      else
        raise Exception.new("#{page} did not return a 200 but instead a #{response.code} to #{response.headers[:location]}")
      end
    else
      response.return!(request, result, &block)
    end }
end

end#end module