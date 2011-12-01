module OpenPage

def nokogiri_open(n_page)
  stitial_count = 0 
  begin
    nok_doc = Nokogiri::HTML(open(n_page))
  rescue => e
    raise Exception.new("#{e.message} on "+n_page.to_s )
  end#end Exception
  while nok_doc.at_css('div#disable')
    begin
      nok_doc = Nokogiri::HTML(open(n_page))
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+n_page.to_s )
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise Exception.new("An endless stitial loop on #{n_page} prevented this test case from running")
    elsif stitial_count > 2
      begin
        nok_doc = Nokogiri::HTML(open(n_page+"?special=noads"))
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+n_page.to_s)
      end#end Exception
    end
  end#end while
  return nok_doc
end#end def

def rest_client_open(r_page)
  stitial_count = 0
  begin
    rest_doc = RestClient.get(r_page)
  rescue => e
    raise Exception.new("#{e.message} on "+r_page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = RestClient.get(r_page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+r_page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = RestClient.get(r_page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+r_page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

def rest_client_not_301_home_open(r2_page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_301_home(r2_page)
  rescue => e
    raise Exception.new("#{e.message} on "+r2_page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_301_home(r2_page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+r2_page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_301_home(r2_page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+r2_page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end

def rest_client_not_310_open(r3_page)
  stitial_count = 0
  begin
    rest_doc = rest_client_not_310(r3_page)
  rescue => e
    raise Exception.new("#{e.message} on "+r3_page.to_s)
  end#end Exception
  while Nokogiri::HTML(rest_doc.body).at_css('div#disable')
    begin
      rest_doc = rest_client_not_310(r3_page)
    rescue => e
      raise Exception.new("#{e.message} (after skipping a stitial) on "+r3_page.to_s)
    end#end Exception
    stitial_count +=1
    if stitial_count > 3
      raise "An endless stitial loop prevented this test case from running"
    elsif stitial_count > 2
      begin
        rest_doc = rest_client_not_310(r3_page+"?special=noads")
      rescue => e
        raise Exception.new("#{e.message} (with special=stital) on "+r3_page.to_s)
      end#end Exception
    end
  end#end while
  return rest_doc
end


def rest_client_not_301_home(r4_page)
  RestClient.get(r4_page){ |response, request, result, &block|
    if response.code == 301
      if ["http://www.ign.com", "http://www.ign.com/"].include? response.headers[:location]
        raise Exception.new("#{r4_page} did not return a 200 but instead a #{response.code} to #{response.headers[:location]}")
      else
        response.return!(request, result, &block)
      end
    else
      response.return!(request, result, &block)
    end }
end

def rest_client_not_310(r5_page)
  RestClient.get(r5_page){ |response, request, result, &block|
    if response.code == 301
      if [/4\d\d/, /5\d\d/].include? response.follow_redirection(request, result, &block).code
        response.follow_redirection(request, result, &block)
      else
        raise Exception.new("#{r5_page} did not return a 200 but instead a #{response.code} to #{response.headers[:location]}")
      end
    else
      response.return!(request, result, &block)
    end }
end

end#end module