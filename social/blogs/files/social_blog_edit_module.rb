require "rubygems"
gem "selenium-client"
require "selenium/client"

module SocialBlogEditMod

  def social_edit_blog
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
	
	# CLICK 'POST' LINK
	@selenium.click "css=a[href='edit.php']"
	@selenium.wait_for_page_to_load "30000"
	
	# CLICK FIRST BLOG ENTRY
	@selenium.click "css=a.row-title"
	@selenium.wait_for_page_to_load "30000"
	
	# STORE TITLE AND BODY OF BLOG ENTRY
	title = @selenium.get_text("css=span#editable-post-name")
    body = @selenium.get_text("css=body#tinymce p")
	puts title
	puts body
	
	# TYPE TITLE
	i = rand(10000) + 999
	i = i.to_s
	@selenium.click "title-prompt-text"
    @selenium.type "title", ""+i+""
	
	# TYPE BODY
	j = rand(10000) + (999)
	j = j.to_s
	@selenium.click "tinymce"
	@selenium.type "tinymce", ""+j+""
	sleep 3
	
	# CLICK UPDATE
	@selenium.click "css=input#publish"
	@selenium.wait_for_page_to_load "30000"
	
	# 'POST UPDATED' NOTIFICATION APPEARS
	begin
        assert /^[\s\S]*Post updated[\s\S]*$/ =~ @selenium.get_text("css=div#message"), "The 'Post updated' notification did not appear after editing and updaing the first blog entry."
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

	# CLICK 'POSTS' LINK
	@selenium.click "css=a[href='edit.php']"
	@selenium.wait_for_page_to_load "30000"
	
	# CLICK FIRST BLOG ENTRY
	@selenium.click "css=a.row-title"
	@selenium.wait_for_page_to_load "30000"
	
	# VERIFY BODY TEXT MATCHES WHAT WAS JUST ENTERED
	begin
		assert_equal j, @selenium.get_text("css=body#tinymce p"), "The blog edit changes did not appear to update in Wordpress when viewing the edited post in the 'Edit Post' interface of the dashboard"
	rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# BACK TO BLOG PAGE, WAIT 20 SECOND, RELOAD
	#@selenium.open "http://www.ign.com/blogs/clay.ign"
	#sleep 20
	#@selenium.refresh
	#@selenium.wait_for_page_to_load "30000"
	
	# VERIFY TITLE OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
	#begin
    #    assert_equal i, @selenium.get_text("css=div#content div[class='post type-post']  a"), "After editing the first blog #entry and waiting 20 seconds, the blog title did not update under the Blog tab blogroll; this error is likely due to the #content API being slow"
    #rescue Test::Unit::AssertionFailedError
    #   @verification_errors << $!
    #end
	
	# VERIFY BODY OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
    #begin
    #   assert_equal j, @selenium.get_text("css=div#content div:nth-child(2) > div.entry p:nth-child(2)"), "After editing the #first blog entry and waiting 20 seconds, the blog body did not update under the Blog tab blogroll; this error is likely #due to the content API being slow"
    #rescue Test::Unit::AssertionFailedError
    #   @verification_errors << $!
    #end
  end
end