class FrontPage < Page

  def open(url="/")
    @client.open(url)  
  end

  def is_element_present(element)
	@client.is_element.present(element)
  end
end