module GlobalHeaderNav

  def check_global_header_nav

    it "should display the global header once" do
      @selenium.find_elements(:css => "div#ignHeader div#ignHeader-userBar").count.should == 1
      @selenium.find_element(:css => "div#ignHeader div#ignHeader-userBar").displayed?.should be_true
    end

    it "should display the global nav once" do
      @selenium.find_elements(:css => "div#ignHeader div#ignHeader-navigation").count.should == 1
      @selenium.find_element(:css => "div#ignHeader div#ignHeader-navigation").displayed?.should be_true
    end

  end

  def check_header_signed_in

    it "should display in the signed-in state" do
      @selenium.find_elements(:css => "div#ignHeader img.userIcon").count.should == 1
      @selenium.find_element(:css => "div#ignHeader img.userIcon").displayed?.should be_true

      @selenium.find_elements(:css => "div#ignHeader a.userOptions-link").count.should == 4

      @selenium.find_elements(:css => "div#ignHeader div.userLevel").count.should == 1
      @selenium.find_element(:css => "div#ignHeader div.userLevel").displayed?.should be_true
      @selenium.find_element(:css => "div#ignHeader div.userLevel").text.should == 'My Stuff'
    end

  end

  def check_header_signed_out

    it 'should display in the signed-out state' do
      @selenium.find_elements(:css => "div#ignHeader a.ignHeader-loginLink").count.should == 1
      @selenium.find_element(:css => "div#ignHeader a.ignHeader-loginLink").displayed?.should be_true
      @selenium.find_element(:css => "div#ignHeader a.ignHeader-loginLink").attribute('href').to_s.match(/s.ign.com\/signin/).should be_true

      @selenium.find_elements(:css => "div#ignHeader a.ignHeader-registerLink").count.should == 1
      @selenium.find_element(:css => "div#ignHeader a.ignHeader-registerLink").displayed?.should be_true
      @selenium.find_element(:css => "div#ignHeader a.ignHeader-registerLink").attribute('href').to_s.match(/s.ign.com\/register/).should be_true
    end

  end
  
  def checker_header_signs_in
    
    it "should sign in" do
      sign_in_button = @selenium.find_element(:css => "div#ignHeader a.ignHeader-loginLink")
      sign_in_button.click
      @selenium.switch_to.frame 'ignRegistrationModal'
      @wait.until { @selenium.find_element(:css => "form#signinForm").displayed? }
      
      email_field = @selenium.find_element :css => 'input#email'
      password_field = @selenium.find_element :css => 'input#password'
      sign_in_button = @selenium.find_element :css => 'input.ignsignin-formButton'
      
      email = 'smoketest@testign.com'
      password = 'testpassword' 
      
      email_field.send_keys email
      password_field.send_keys password
      sign_in_button.click

      @selenium.switch_to.default_content 
      @wait.until { @selenium.find_element(:css => "div#ignHeader img.userIcon").displayed?.should be_true }
    end
    
  end

end