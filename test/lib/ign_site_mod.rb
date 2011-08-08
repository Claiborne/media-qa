module IGNSiteMod

  def open(url)
    @client.open(url)
    while @client.get_title == "IGN Advertisement"                                     	    		 
      @client.click("css=a")
      @client.wait_for_page_to_load "40"
  	end
  end
  
  def click(locator)
    @client.click(locator)
    @client.wait_for_page_to_load "40"
    while @client.get_title == "IGN Advertisement"                             	      
      @client.click("css=a")
      @client.wait_for_page_to_load "40"
	end
  end
  
  def refresh
  	@client.refresh
    @client.wait_for_page_to_load "40"
    while @client.get_title == "IGN Advertisement"                                     	    		 
      @client.click("css=a")
      @client.wait_for_page_to_load "40"
  	end
  end
  
end
