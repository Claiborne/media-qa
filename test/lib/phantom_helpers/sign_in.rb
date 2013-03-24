module SignIn

  def do_sign_in(selenium, email, password, r=nil)
    if r
      selenium.get "https://s.ign.com/login?r=#{r}"
    else
      selenium.get "https://s.ign.com/login"
    end

    email_field = selenium.find_element :css => 'input#email'
    password_field = selenium.find_element :css => 'input#password'
    sign_in_button = selenium.find_element :css => 'input.ignsignin-formButton'

    email_field.send_keys email
    password_field.send_keys password
    sign_in_button.click

    selenium.current_url.should == r if r

  end

  def sign_in(r)
    it "should sign in" do
      PathConfig.config_path = File.dirname(__FILE__) + "/../../config/boards.yml"
      config = PathConfig.new
      base_url = "http://#{config.options['baseurl']}"
      do_sign_in(@selenium, 'smoketest@testign.com', 'testpassword', "#{base_url}#{r}")
    end
  end

  def sign_in_without_redirect
    it "should sign in" do
      do_sign_in(@selenium, 'smoketest@testign.com', 'testpassword')
    end
  end

end