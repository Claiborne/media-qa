require 'page'

class SignupPage < Page
  def open()
    @client.open('http://login.ign.com/subscribe/signup.aspx')  
  end
  
  def login_existing_account(info)   
    @selenium.type('_ctl0_PageBody_signupPage_loginControl_overlayEmailTextBox', info[:email])
    @selenium.type('_ctl0_PageBody_signupPage_loginControl_overlayPasswordTextBox', info[:password])
    @selenium.click_and_wait('loginacct-btn')
   end
end