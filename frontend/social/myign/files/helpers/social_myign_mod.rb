
module SocialMyIGNMod

  def sign_in(acct)
	@selenium.open "http://stg-my.ign.com/login?r=http://stg-my.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "#{acct}test@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def verify_title(title, desc)
    begin
      assert @selenium.get_title.match(/#{title}/), "Unable to verify actually webpage title matches #{title} when #{desc}"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end
  
  def verify_url(url, desc)
    begin
      assert @selenium.get_location.match(/#{url}/), "Unable to verify actual url matches #{url} when #{desc}"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end

  def open(url)
    @selenium.open(url)
    while @selenium.get_title() == "IGN Advertisement"
      @selenium.click("css=div#header-text a")
      @selenium.wait_for_page_to_load "40"
    end
  end
  
  def wait_for_page_to_load(timeout)
	@selenium.wait_for_page_to_load(timeout)
    while @selenium.get_title() == "IGN Advertisement"
		@selenium.click("css=div#header-text a")
		@selenium.wait_for_page_to_load "40"
    end
  end
  
  def rand_gen
	rand_num = rand(1000000) + 1000
	"test"+rand_num.to_s+"test"
  end
  
  def log_out
	@selenium.open("http://stg-my.ign.com/logout")
  end
end