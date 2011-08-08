
module SocialMyIGNPagesFAQMod

  def check_faq_page
  
	#Check text appears (string > 40) in all div.help_wrappers
	@selenium.open("http://my.ign.com/help")
	
	paragraphs = @selenium.get_xpath_count("//div[@id='bodyModulesContainer']/div[@class='help_wrapper']")
	2.upto(paragraphs.to_i+1) do |i|
		text = @selenium.get_text("css=div#bodyModulesContainer div:nth-child(#{i})")
		if text.length > 40 then bool = "true" 
			else bool = ""
		end
		begin
			assert_equal "true", bool, "Unable to verify the #{i} numbered FAQ wrapper (div.help_wrapper) contains text on the MyIGN FAQ page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
end