    if @selenium.is_element_present("css=div.contentHead h2.contentTitle a")
		text = @selenium.get_text("css=div.contentHead h2.contentTitle a")
			if text.length > 1 then bool = "true" 
				else bool = ""
			end
		begin
			assert_equal "true", bool, "Unable to verify the object's title is present in the object header on the index pages"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else 
		begin
			assert @selenium.is_element_present("css=div.contentHead h2.contentTitle a"), "Unable to verify the object's title is present in the object header on the index pages"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end