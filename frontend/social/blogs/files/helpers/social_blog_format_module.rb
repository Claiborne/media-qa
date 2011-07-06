
module SocialBlogFormatMod

  def new_post
	@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
	@selenium.wait_for_page_to_load "40"
	@selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
	
	# NEW POST
	@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
	@selenium.wait_for_page_to_load "40"

	# IF MISDIRECTED TO LOGNIN, REDO STEPS
	while @selenium.get_title == "Login - IGN"
		@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
		@selenium.wait_for_page_to_load "40"
		@selenium.click "emailField"
		@selenium.type "emailField", "smoketest@testign.com"
		@selenium.type "passwordField", "testpassword"
		@selenium.click "signinButton"
		@selenium.wait_for_page_to_load "40"
		
		# NEW POST
		@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
		@selenium.wait_for_page_to_load "40"
	end
  end
	
  def type_title
	i = (rand(10000) + 999).to_s
	@selenium.type "title", ""+i+""
  end
	
  def type_body
	@selenium.key_press_native "55"
  end
  
  def preview
	@selenium.click "save-post"
	@selenium.wait_for_page_to_load "40"
	sleep 1
    href = @selenium.get_attribute("css=div#message p a@href")
	@selenium.open href
	@selenium.wait_for_page_to_load "40"
  end
end