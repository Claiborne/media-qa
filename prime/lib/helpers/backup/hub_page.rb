class HubPage < Page
  include ScreenshotHelper
  
  def disable_ads
    visit("http://dev.login.ign.com/prime/hub.aspx")
    assert_element_not_present("//ul[@id='member-settings']/li[1]/label[@class='checked']")
    @client.click('disableAdsCheckBox')
    @client.click('uxSubmitEmailOptIns')  
    @client.wait_for_page_to_load('30000')
    assert_element("//ul[@id='member-settings']/li[1]/label[@class='checked']")
  end
  
  def enable_ads
    
    
  end
  
  def verify_hub_page(status, login_info)
    @client.open("http://dev.login.ign.com/prime/hub.aspx")
    #if user isn't logged in then lets log them in
    if @client.is_text_present('Log In With Email Address')
      login(login_info)
    end  
    case status
      when 'enabled'
        assert_element_not_present("//ul[@id='member-settings']/li[1]/label[@class='checked']")
      when 'disabled'
        assert_element("//ul[@id='member-settings']/li[1]/label[@class='checked']")
    end    
  end
end