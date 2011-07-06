require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/social_blog_format_module"


class SocialBlogFormatPost < Test::Unit::TestCase

  include SocialBlogFormatMod

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
  
  def test_social_blog_format_post
	new_post
	type_title
	
	# FORMAT BOLD, ITALIC, STRIKE, BULLET
	@selenium.click "css=a#content_bold span"
	@selenium.click "css=a#content_italic span"
	@selenium.click "css=a#content_strikethrough span"
	@selenium.click "css=a#content_bullist span"
	
	sleep 1
	type_body
	preview
	begin
		assert @selenium.is_element_present("css=div.entry ul li span[style='text-decoration: line-through;'] em strong"), "When the formatted blog post was viewed, one of the following did not appear: bold, em, line-though, and/or ul li"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end

	@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
	@selenium.wait_for_page_to_load "40"
	type_title
	
	# FORMAT NUMLIST, BLOCKQUOTE, COLOR
	@selenium.click "css=a#content_numlist span"
	@selenium.click "css=a#content_blockquote span"
	@selenium.click "content_forecolor_open"
	@selenium.click "css=div#content_forecolor_menu td a[style='background-color: rgb(255, 0, 0);']"
	
	sleep 1
	type_body
	preview
	begin
		assert @selenium.is_element_present("css=div.entry ol blockquote li span[style='color: rgb(255, 0, 0);']"), "When the formatted blog post was viewed, one of the following did not appear: ol li, blockquote, and/or red text"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
	@selenium.wait_for_page_to_load "40"
	type_title
	
	# HEADING 1, ALIGN CENTER
	@selenium.click "css=a#content_justifycenter span"
	@selenium.click "css=a#content_formatselect_open span"
	@selenium.click "css=tr#mce_4 span[title='Heading 1']"
	
	sleep 1
	type_body
	preview
	begin
		assert @selenium.is_element_present("css=div.entry h1[style=text-align: center;]"), "When the formatted blog post was viewed, one of the following did not appear: h1 or text-align center"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
end