require "rubygems"
gem "selenium-client"
require "selenium/client"

module SocialBlogDeleteMod

  def social_delete_blog
  # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
	@selenium.wait_for_page_to_load "30000"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
	
	# OPEN MY IGN HOME
    @selenium.open "http://my.ign.com/home"
    @selenium.wait_for_page_to_load "30000"
	
	# CLICK BLOG TAB
    @selenium.click "link=Blog"
    @selenium.wait_for_page_to_load "30000"
	
	# CLICK EDIT FIRST BLOG ENTRY
	@selenium.click "link=Write a New Post"
    @selenium.wait_for_page_to_load "30000"
	
	# IF MISDIRECTED TO LOGNIN, REDO STEPS
	while @selenium.get_title == "IGN Login"
		@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "emailField"
		@selenium.type "emailField", "smoketest@testign.com"
		@selenium.type "passwordField", "testpassword"
		@selenium.click "signinButton"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "http://my.ign.com/home"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Blog"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Write a New Post"
		@selenium.wait_for_page_to_load "30000"
	end
	
	# CLICK 'POSTS' LINK
	@selenium.click "css=a[href='edit.php']"
	@selenium.wait_for_page_to_load "30000"
	
	# CLICK FIRST BLOG ENTRY
	@selenium.click "css=a.row-title"
	@selenium.wait_for_page_to_load "30000"
	
	# STORE TITLE AND BODY OF BLOG ENTRY
	title = @selenium.get_text("css=span#editable-post-name")
    body = @selenium.get_text("css=body#tinymce p")

	# CLICK 'MOVE TO TRASH' TO DELETE POST
	@selenium.click "link=Move to Trash"
    @selenium.wait_for_page_to_load "30000"
	
	# 'ITEM MOVED TO TRASH' NOTIFICATION APPEARS
	begin
        assert /^[\s\S]*Item moved to the trash[\s\S]*$/ =~ @selenium.get_text("css=div#message p"), "The 'Item move to the trash' notification did not appear after deleting a post in the 'Edit Post' page of the blog dashboard"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# CLICK 'POSTS' LINK
	@selenium.click "css=a[href='edit.php']"
	@selenium.wait_for_page_to_load "30000"
	
	# BLOG ENTRY IS GONE, HAS BEEN DELETED
	begin
        assert title != @selenium.get_text("css=a.row-title"), "Blog entry is not gone and still appears in the dashboard"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

	# BACK TO BLOG PAGE, WAIT 20 SECOND, RELOAD
	@selenium.open "http://www.ign.com/blogs/clay.ign"
	sleep 20
	@selenium.refresh
	@selenium.wait_for_page_to_load "30000"
	
	# BLOG ENTRY IS GONE, HAS BEEN DELETED
	begin
        assert title != @selenium.get_text("css=div#content div[class='post type-post']  a"), "After deleting the latest post and waiting 20 second, the blog title was not missing under the Blog tab blogroll; this error is likely due to the content API being slow"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	begin
        assert body != @selenium.get_text("css=div#content div[class='post type-post'] div.entry p:nth-child(2)"), "After deleting the latest post and waiting 20 second, the blog body was not missing under the Blog tab blogroll; this error is likely due to the content API being slow"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end