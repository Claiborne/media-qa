require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'


describe "user management" do

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/topaz_api.yml"
    @config = Configuration.new
    now = Time.now
    
    @time_stamp = "#{now.strftime("%Y%m%d%H%M%S")}_#{(rand(100)+1)*9999}"
    #@conn = Mongo::Connection.new
    #@db = @conn.db('topaz')
    #@db.drop_collection('users')    
    #@db.drop_collection('tickets')    
    
  end

  after(:each) do

  end

  
# GET - config info
  it "should return config info" do
    response = RestClient.get "http://#{@config.options['baseurl']}/config"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.should have_key("environment")
    data.should have_key("ticketExpiration")
    data.should have_key("mongodb")
    data.should have_key("environment")
  end


# GET - user info
  it "should return user info" do
    # create account - set up
    user_email = "test_user_#{@time_stamp}@ign.com"    
    user_pwd = "igntest@123"
    provider_name = 'local'
    payload = {'email' => user_email, 'password' => user_pwd, 'provider' => provider_name}

    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']


    # actual test
    response = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['email'].should eql(user_email)
    data['provider'].should eql(provider_name)
    data['active'].should be_true
    #puts data.has_key?('ticket')
    #puts data['ticket']
  end

  it "should return an error message for an invalid user" do
    user_id = "9999999999"
    expected_error_msg = "invalid ObjectId [#{user_id}]"
    response = RestClient.get("http://#{@config.options['baseurl']}/user/#{user_id}"){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }
  end

  it "should return 404 error code when userid is empty" do    
    expected_error_msg = "The requested resource is not found on the server"
    response = RestClient.get("http://#{@config.options['baseurl']}/user/"){|response, request, result|
      response.code.should eql(404)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }
  end


  #GET - search using email address
  it "should return user info when searching a valid email address" do
    # create account - set up
    
    provider_name = 'yahoo'
    user_email = "test_user_#{@time_stamp}@#{provider_name}.com"

    payload = {'email' => user_email, 'provider' => provider_name}

    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    #actual test
    response = RestClient.get("http://#{@config.options['baseurl']}/user/search/#{user_email}/#{provider_name}")
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['id'].should eql(user_id)
    data['email'].should eql(user_email)
  end

  it "should return an error searching an invalid email address" do
    email_address = "somebogusemail@address.com"
    expected_error_msg = "User not found"
    response = RestClient.get("http://#{@config.options['baseurl']}/user/search/#{email_address}/yahoo"){|response, request, result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }
  end


  #POST - user creation
  it "should create local (IGN) user" do
    
    user_email = "test_user_#{@time_stamp}_43534@ign.com"    
    user_pwd = "igntest@123"
    provider_name = 'local'
    payload = {'email' => user_email, 'password' => user_pwd, 'provider' => provider_name}

    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    gresponse = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['id'].should eql(user_id)
    gdata['email'].should eql(user_email)
    gdata['provider'].should eql(provider_name)
  end

  it "should create user from yahoo provider" do
    user_email = "test_user_#{@time_stamp}@yahoo.com"
    provider_name = "yahoo"
    payload = {"email" => user_email,"provider" => provider_name}
    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    gresponse = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['id'].should eql(user_id)
    gdata['email'].should eql(user_email)
    gdata['provider'].should eql(provider_name)
  end

  it "should create user from google provider" do
    user_email = "test_user_#{@time_stamp}@google.com"
    provider_name = "google"
    payload = {"email" => user_email,"provider" => provider_name}
    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    gresponse = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['id'].should eql(user_id)
    gdata['email'].should eql(user_email)
    gdata['provider'].should eql(provider_name)
  end

  it "should create user from facebook provider" do
    provider_name = "facebook"
    user_email = "test_user_#{@time_stamp}@#{provider_name}.com"

    payload = {"email" => user_email,"provider" => provider_name}
    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    gresponse = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['id'].should eql(user_id)
    gdata['email'].should eql(user_email)
    gdata['provider'].should eql(provider_name)
  end

  it "should return an error for non supported provider (i.e. aol)" do
    
    user_email = "test_user_#{@time_stamp}@aol.com"
    provider_name = 'aol'
    expected_error_msg = 'Provider is invalid'
    payload = {"email" => user_email,"provider" => provider_name}
    response = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should == expected_error_msg
    }
  end

  it "should return an error when provider field is empty" do
    
    user_email = "test_user_#{@time_stamp}@facebook.com"
    provider_name = ''
    expected_error_msg = 'Provider is invalid'
    payload = {"email" => user_email,"provider" => provider_name}
    response = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should == expected_error_msg
    }
  end

  it "should return an error when creating an user already exist" do

    user_email = "test_user_#{@time_stamp}_123@ign.com"
    provider_name = 'local'
    error_msg = "User is not valid"
    payload = {"email" => user_email,"provider" => provider_name, "password" => "test123"}
    response = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json')
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']

    eresponse = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'){|eresponse,request,result|
      eresponse.code.should eql(500)
      edata = JSON.parse(eresponse.body)
      edata.should have_key('error')
      edata['error'].should eql(error_msg)
    }
  end

  it "should return an error when email field is empty" do
    provider_name = 'google'
    user_email = "test_user_#{@time_stamp}@#{provider_name}.com"
    payload = {"email" => "","provider" => provider_name}
    expected_error_msg = 'Email is invalid'
    response = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }
  end

  it "should return an error using an malformed email" do
    provider_name = 'google'
    user_email = "test_user_#{@time_stamp}#{provider_name}.com"
    payload = {"email" => user_email,"provider" => provider_name}
    expected_error_msg = 'Email is invalid'
    response = RestClient.post( "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }
  end

  #Post - update existing user
  it "update an existing user in the system" do
    provider_name = "google"
    user_email = "test_user_#{@time_stamp}_456@google.com"
    
    payload = {"email" => user_email,"provider" => provider_name}

    #create account
    cresponse = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json ,:content_type => 'application/json'
    cresponse.code.should eql(200)
    cdata = JSON.parse(cresponse.body)
    cdata.should have_key('id')
    user_id = cdata['id']

    gresponse = RestClient.get "http://#{@config.options['baseurl']}/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['id'].should eql(user_id)
    gdata['email'].should eql(user_email)
    gdata['provider'].should eql(provider_name)

    #update account
    mod_email = "test_user_#{@time_stamp}_456_mod@google.com"
    uresponse = RestClient.post "http://#{@config.options['baseurl']}/user/#{user_id}", {'email' => mod_email}.to_json ,:content_type => 'application/json'
    uresponse.code.should eql(200)
    udata = JSON.parse(uresponse.body)
    udata.should have_key('id')
    udata['email'].should eql(mod_email)
  end

  #POST - delete user
  it "should delete an existing user" do
    # create account - set up

    provider_name = 'yahoo'
    user_email = "test_user_#{@time_stamp}@#{provider_name}.com"

    payload = {'email' => user_email, 'provider' => provider_name}

    response = RestClient.post "http://#{@config.options['baseurl']}/user/register", payload.to_json,:content_type => 'application/json'
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata.should have_key('id')
    user_id = pdata['id']
    # actual test
    dresponse = RestClient.delete "http://#{@config.options['baseurl']}/user/#{user_id}"
    dresponse.code.should eql(200)
    
    ddata = JSON.parse(dresponse.body)
    ddata['id'].should eql(user_id) 

    expected_error_msg = "User not found"
    response = RestClient.get("http://#{@config.options['baseurl']}/user/#{user_id}"){|response,request,result|
      response.code.should eql(500)
      data = JSON.parse(response.body)
      data.should have_key('error')
      data['error'].should eql(expected_error_msg)
    }

  end

end

