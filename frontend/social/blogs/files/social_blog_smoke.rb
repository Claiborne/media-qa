  require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/social_blog_edit_module"
require "files/helpers/social_blog_delete_module"

class SocialBlogSmoke < Test::Unit::TestCase

include SocialBlogEditMod
include SocialBlogDeleteMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows SSL OK",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_blog_smoke
  
	# SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
	
	# OPEN MY IGN PROFILE
    @selenium.open "http://people.ign.com/clay.ign"
    @selenium.wait_for_page_to_load "40"
	
	# CLICK BLOGS
	@selenium.click "css=a[href*='www.ign.com/blogs/clay.ign']"
	@selenium.wait_for_page_to_load "40"
	
	# OPEN WRITE A NEW POST
	@selenium.click "link=Write a New Post"
    @selenium.wait_for_page_to_load "40"

	
	# IF MISDIRECTED TO LOGNIN, REDO STEPS
	while @selenium.get_title == "Login - IGN"
		puts "****************NOTICE****************"
		puts "'Write a New Post' link was misdirected to IGN Login page. This has been a known issue and this script is programmed to run around this issue"
		puts ""
		@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
		@selenium.wait_for_page_to_load "40"
		@selenium.click "emailField"
		@selenium.type "emailField", "smoketest@testign.com"
		@selenium.type "passwordField", "testpassword"
		@selenium.click "signinButton"
		@selenium.wait_for_page_to_load "40"
		@selenium.open "http://people.ign.com/clay.ign"
		@selenium.wait_for_page_to_load "40"
		@selenium.click "css=a[href*='www.ign.com/blogs/clay.ign']"
		@selenium.wait_for_page_to_load "40"
		@selenium.click "link=Write a New Post"
		@selenium.wait_for_page_to_load "40"
	end
	
	# TYPE TITLE
	i = rand(10000) + 999
	i = i.to_s
	@selenium.click "title-prompt-text"
    @selenium.type "title", ""+i+""
	
	# TYPE BODY
	j = rand(10000) + 999
	j = j.to_s
	@selenium.click "tinymce"
	@selenium.type "tinymce", ""+j+""
	sleep 3
	
	# PUBLISH
	@selenium.click "publish"
    @selenium.wait_for_page_to_load "40"
	
	if @selenium.is_text_present("You are posting too quickly. Slow down.")
	puts "****************WARNING****************"
	puts "This test is being run too quickly: only 1 blog post per minute is allowed. Please rerun the test after 1 minute"
	puts ""
	end
	
	# 'POST PUBLISHED' NOTIFICATION APPEARS
	begin
        assert /^[\s\S]*Post published[\s\S]*$/ =~ @selenium.get_text("css=div#message"), "The 'Post Pulished' notification did not appear after publishing the new blog post."
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	# CLICK 'VIEW POST'
	@selenium.click "link=View post"
    @selenium.wait_for_page_to_load "40"
	
	# VERIFY TITLE OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
	begin
        assert_equal i, @selenium.get_text("css=div#content div:nth-child(2) > h2"), "After publishing the new post, when the 'View Post' linked was clicked, the blog title was missing"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY BODY OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
    begin
        assert_equal j, @selenium.get_text("css=div#content div:nth-child(2) > div.entry p:nth-child(2)"), "After publishing the new post, when the 'View Post' linked was clicked, the blog body was missing"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# VERIFY CONTENT API SEES IT AS PUBLISHED
	blogid = @selenium.get_attribute("css=div#content div[class='post type-post']@id")
	blogid = blogid.delete "post-"
	@selenium.open "http://api.ign.com/v2/articles/"+blogid+".json"
	@selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("state: \"published\""), "The blog post's state is not marked as 'published' in the content API"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# BACK TO BLOG PAGE AND WAIT
	#@selenium.open "http://www.ign.com/blogs/clay.ign"
	#sleep 20
	#@selenium.refresh
	#@selenium.wait_for_page_to_load "40"
	#sleep 2
	
	# VERIFY TITLE OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
	#begin
    #    assert_equal i, @selenium.get_text("css=div#content div[class='post type-post']  a"), "After publishing the new post #and waiting 20 second, the blog title was missing under the Blog tab blogroll; this error is likely due to the content #API being slow"
    #rescue Test::Unit::AssertionFailedError
    #    @verification_errors << $!
    #end
	#
	# VERIFY BODY OF BLOG POST DISPLAYS, MATCHES WHAT WAS ENTERED ABOVE
    #begin
    #    assert_equal j, @selenium.get_text("css=div#content div:nth-child(2) > div.entry p:nth-child(2)"), "After publishing #the new post and waiting 20 second, the blog body was missing under the Blog tab blogroll; this error is likely due to #the content API being slow"
    #rescue Test::Unit::AssertionFailedError
     #   @verification_errors << $!
    #end
  end

  #def test_za_edit_blog
  #social_edit_blog
  #end
  
  #def test_zb_delete_blog
  #social_delete_blog
  #end
end