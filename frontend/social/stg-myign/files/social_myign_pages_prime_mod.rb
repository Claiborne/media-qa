
module SocialMyIGNPagesPrimeMod

  def check_prime_page
  
	#Check text is present
	begin
		assert /Exclusive Game Betas/ =~ @selenium.get_text("css=h2[class='hub-hdr-icon hub-gun']"), "Unable to verify content displays on MyIGN Prime page ('Exclusive Game Betas' text not found)"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Check text is present
	begin
		assert /Billing Info/ =~ @selenium.get_text("css=div#sidebar"), "Unable to verify content displays on MyIGN Prime page ('Billing Info' text not found)"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Check header content is present
	begin
		assert @selenium.is_element_present("css=div.prime-hdrcontent"), "Unable to verify the content header is visible on the MyIGN Prime page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  
  end
end