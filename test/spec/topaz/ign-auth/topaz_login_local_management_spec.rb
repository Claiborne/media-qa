require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "login local management" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/topaz_api.yml"
    @config = Configuration.new

    now = Time.now
    @time_stamp = now.strftime("%Y%m%d%H%M%S")

    @provider = 'local'
    @email = "test_user_#{@time_stamp}_#{Random.rand(100000-999999)}@yahoo.com"
    @password = "igntest@123"
    payload = {'email' => @email, 'password' => @password, 'provider' => @provider}
    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,{:content_type => 'application/json'}
    response.code.should eql(200)
    local_data = JSON.parse(response.body)
    @user_id = local_data['id']
  end

  before(:each) do

  end

  after(:each) do

  end

  #yahoo
  it "should login me in with email, password and provider" do
    payload = {'email' => @email , 'password' => @password ,'provider' => @provider}
    response = RestClient.post "http://#{@config.options['baseurl']}/login",payload.to_json,:content_type => "application/json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    #puts "ticket - #{data['ticket']}"
    data.should have_key('ticket')
  end

  it "should login with a valid ticket" do
    #set up
    payload = {'email' => @email , 'password' => @password, 'provider' => @provider}
    response = RestClient.post "http://#{@config.options['baseurl']}/login",payload.to_json,:content_type => "application/json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    ticket  = data['ticket']

    tpayload = {'ticket' => ticket}
    response = RestClient.post "http://#{@config.options['baseurl']}/login",payload.to_json,:content_type => "application/json"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    #puts "ticket - #{data['ticket']}"

  end

  it "should return login count incremented by 1" do
    # set up
    response = RestClient.get "http://#{@config.options['baseurl']}/user/#{@user_id}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    login_count = data['loginCount'] 

    # actual test
    payload = {'email' => @email , 'password' => @password, 'provider' => @provider}
    lresponse = RestClient.post "http://#{@config.options['baseurl']}/login",payload.to_json,:content_type => "application/json"
    lresponse.code.should eql(200)
    ldata = JSON.parse(lresponse.body)
    ldata['loginCount'].should_not eql(login_count)
  end

  it "should return an error message when provider is incorrect" do
    payload = {'email' => @email, 'provider' => 'facebook'}
    expected_error_msg = "User not found"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(500)

      data = JSON.parse(response.body)
      data['error'].should eql(expected_error_msg)
    }
  end

  it "should return an error message when provider is missing" do
    payload = {'email' => @email, 'password' => @password}
    expected_error_msg = "key not found: provider"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(500)

      data = JSON.parse(response.body)
      data['error'].should eql(expected_error_msg)
    }

  end

  it "should return an error message when email is missing" do
    payload = {'provider' => @provider, 'password' => @password}
    expected_error_msg = "key not found: email"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(500)

      data = JSON.parse(response.body)
      data['error'].should eql(expected_error_msg)
    }

  end

  it "should return an error message when password is missing" do
    payload = {'provider' => @provider, 'provider' => @provider}
    expected_error_msg = "key not found: password"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(500)

      data = JSON.parse(response.body)
      data['error'].should eql(expected_error_msg)
    }

  end

  it "should return an error message when email is malformed" do

    malformed_email = @email.gsub(/@/,'')
    payload = {'email' => malformed_email, 'password' => @password}
    expected_error_msg = "Email is invalid"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
      response.code.should eql(500)

      data = JSON.parse(response.body)
      data['error'].should eql(expected_error_msg)
    }


  end

  it "should return an error message when account is inactive" do
     # set up
     upayload = {'active' => 'false'}
     #puts "user id - #{@user_id}"
     RestClient.post( "http://#{@config.options['baseurl']}/user/#{@user_id}", upayload.to_json,{:content_type => 'application/json'}){|uresponse, request, result|
       uresponse.code.should eql(200)
     }

     # actual test
     payload = {'email' => @email, 'password' => @password, 'provider' => @provider}
     expected_error_msg = "User is not active"
     response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
       response.code.should eql(500)

       data = JSON.parse(response.body)
       data['error'].should eql(expected_error_msg)
    }

     # clean up
     upayload['active']= 'true'
     #puts "user id - #{@user_id}"
     RestClient.post( "http://#{@config.options['baseurl']}/user/#{@user_id}", upayload.to_json,{:content_type => 'application/json'}){|uresponse, request, result|
       uresponse.code.should eql(200)
     }

  end

  it "should return an error when account is deleted" do
    # set up 
    user_email = "test_user_#{Random.rand(10000-99999)}@yahoo.com"

    payload = {'email' => user_email, 'password' => @password, 'provider' => @provider}

    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    dresponse = RestClient.delete "http://#{@config.options['baseurl']}/user/#{user_id}"
    dresponse.code.should eql(200)

    ddata = JSON.parse(dresponse.body)
    ddata['id'].should eql(user_id)
    # actual test

    expected_error_msg = "User not found"
    response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'}){|response, request, result|
       response.code.should eql(500)

       data = JSON.parse(response.body)
       data['error'].should eql(expected_error_msg)
    }

  end

  it "should return a different ticket when logged in" do 
     # actual test

     ticket_hsh = Hash.new
     (1..3).each{
       payload = {'email' => @email, 'password' => @password, 'provider' => @provider}
       response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'})
       response.code.should eql(200)

       data = JSON.parse(response.body)
       ticket = data['ticket']
       ticket_hsh.should_not have_key(ticket)
       ticket_hsh[ticket ] 
     } 
  end


  # POST logout
  it "should logout when logged in using user id" do

     #set up
     user_email = "test_user_#{Random.rand(10000-99999)}@yahoo.com"

     payload = {'email' => user_email, 'password' => @password, 'provider' => @provider}

     response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
     response.code.should eql(200)
     pdata = JSON.parse(response.body)
     pdata.should have_key('id')
     user_id = pdata['id']


     payload = {'email' => user_email, 'password' => @password, 'provider' => @provider}
     
     response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200)
     li_data = JSON.parse(response.body)
     ticket = li_data['ticket']

     logout_payload = {'id' => user_id}
     response = RestClient.post( "http://#{@config.options['baseurl']}/logout", logout_payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200) 
     lo_data = JSON.parse(response.body)
     lo_data.should have_value(ticket)

  end

  it "should return more than one ticket when logging out" do
     #set up
     MAX = 3
     ticket_hsh = Hash.new
     user_email = "test_user_#{Random.rand(10000-99999)}@yahoo.com"

     payload = {'email' => user_email, 'password' => @password, 'provider' => @provider}

     response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
     response.code.should eql(200)
     pdata = JSON.parse(response.body)
     pdata.should have_key('id')
     user_id = pdata['id']


     payload = {'email' => user_email, 'password' => @password, 'provider' => @provider}
     (1..MAX).each {
       response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'})
       response.code.should eql(200)
       li_data = JSON.parse(response.body)
       ticket_hsh[li_data['ticket']] = ''
     }
     logout_payload = {'id' => user_id}
     response = RestClient.post( "http://#{@config.options['baseurl']}/logout", logout_payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200)
     lo_data = JSON.parse(response.body)
     ticket_hsh.size.should eql(lo_data.size)
     ticket_hsh.each do |ticket,value|
       lo_data.should have_value(ticket)
     end
  end

  it "should return nothing when already logged out" do
     payload = {'email' => @email, 'password' => @password, 'provider' => @provider}

     response = RestClient.post( "http://#{@config.options['baseurl']}/login", payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200)
     li_data = JSON.parse(response.body)

     logout_payload = {'id' => @user_id}
     response = RestClient.post( "http://#{@config.options['baseurl']}/logout", logout_payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200)
     lo_data = JSON.parse(response.body)


     logout_payload = {'id' => @user_id}
     response = RestClient.post( "http://#{@config.options['baseurl']}/logout", logout_payload.to_json,{:content_type => 'application/json'})
     response.code.should eql(200)
     lo_data = JSON.parse(response.body)
     lo_data.should be_empty
  end

end
