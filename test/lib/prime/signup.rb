require 'page'

class SignupPage < Page
  def open()
    @client.open('http://login.ign.com/subscribe/signup.aspx')  
  end
  
  def login(info)   
    @client.type('_ctl0_PageBody_signupPage_loginControl_overlayEmailTextBox', info[:email])
    @client.type('_ctl0_PageBody_signupPage_loginControl_overlayPasswordTextBox', info[:password])
    @client.click('loginacct-btn')
    sleep 5   #todo: make this better
   end
end