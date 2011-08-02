require 'page'

module Oyster
module Social
class IGN_Site < Page
  def visit(url)
    @client.open(url)
    while @client.get_title == "IGN Advertisement"                                     	    		 
      @client.click("css=a")
      @client.wait_for_page_to_load "40"
  	end
  end
  
  def visit_click(locator)
    @client.click(locator)
    @client.wait_for_page_to_load "40"
    while @client.get_title == "IGN Advertisement"                             	      
      @client.click("css=a")
      @client.wait_for_page_to_load "40"
	end
  end
end
end
end