
module IGNHubsIndicesMod

  def sign_in
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def check_hero_box(page)
    for i in 0..4
      begin
          assert @selenium.is_element_present("css=div#hu#{i}l a[href*=http] img[src*=http]") || @selenium.is_element_present("css=div#hu0l a[onclick*='IGN.HeroUnit'] img[src*=http]"), "Unable to verify the #{i} indexed Hero Box feature functions on the #{page} page. An image might not be displayed or it my not link to anywhere"
      rescue Test::Unit::AssertionFailedError
          @verification_errors << $!
      end
	end
  end
  
  def check_hero_thumb(page)
    for i in 0..4
      begin
          assert @selenium.is_element_present("css=ol.thumbs li a[href*=http] img[src*=http]"), "Unable to verify the #{i} indexed Hero Box Thumb functions on the #{page} page. An image might not be displayed or it my not link to anywhere"
      rescue Test::Unit::AssertionFailedError
          @verification_errors << $!
      end
	end
  end
  
end