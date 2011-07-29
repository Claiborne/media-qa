module BlankPageChecker 
  
  def check_blank_page(page)
	#CHECK A THIRD LEVEL DIV IS PRESENT
	begin
		assert @selenium.is_element_present("css=div div div"), "Blank page checker: Unable to verify a third embeded div is found on the following page -- #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	#CHECK > 25 CHARS OF TEXT IS PRESENT
	body_text = @selenium.get_body_text
	begin
		assert body_text.length > 25, "Blank page checker: Unable to verify the length of the body text to the following is greater than 25 on the following page -- #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	#CHECK ONE IMAGE IS PRESENT
	begin
		assert @selenium.is_element_present("css=img[src*='http']"), "Blank page checker: Unable to verify at least one image is found on the following page -- #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
end