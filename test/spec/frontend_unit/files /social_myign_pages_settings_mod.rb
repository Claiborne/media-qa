
module SocialMyIGNPagesSettingsMod

  def check_settings_page
  
	#Define text to check appears on page
	page_text = Array.new
	page_text << "Profile Information"
	page_text << "Upload a new avatar:"
	page_text << "Username"
	page_text << "Upload a new avatar:"
	page_text << "Name:"
	page_text << "About Me:"
	page_text << "Account Settings"
	page_text << "Privacy Settings"
	page_text << "Link With Your Other Networks"
	
	#Check text is present
	page_text.each do |i|
		begin
			assert @selenium.is_text_present(i), "Unable to verify the following text displays on the MyIGN settings page: #{i}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	#Check avatar image visible
	begin
		assert @selenium.is_element_present("css=form#updateProfileForm img#avatar"), "Unable to verify the user's avatar image displays on the MyIGN settings page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
end