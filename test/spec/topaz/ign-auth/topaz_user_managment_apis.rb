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
    @time_stamp = now.strftime("%Y%m%d%H%M%S")
    
  end

  after(:each) do

  end

  # GET - user info
  it "should return user info" do
    user_id = "4000105";

    response = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'ok'
  end

  it "should return an error message for an invalid user" do
    user_id = "9999999999"

    response = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'error'
  end

  it "should return 404 error code when userid is empty" do    
    response = RestClient.get("http://#{@config.options['baseurl']}/auth/user/"){|response, request, result|
    response.code.should eql(404)
    response.body.should include('<h1>Not found</h1>')
    }
  end

  #POST - user creation
  it "should create local (IGN) user" do
    
    email = "test_user_#{@time_stamp}@ign.com"    
    payload = "{email:#{email},password:''}"

    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata['status'].should == 'ok'
    user_id = pdata['entry']
    gresponse = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['entry']['active'].should be_true
    gdata['entry']['provider'].should == 'local'

  end

  it "should create user from yahoo provider" do
    email = "test_user_#{@time_stamp}@yahoo.com"
    provider_name = "yahoo"
    payload = "{email:#{email},provider:#{provider_name}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata['status'].should == 'ok'
    user_id = pdata['entry']
    gresponse = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['entry']['active'].should be_true
    gdata['entry']['provider'].should == provider_name
  end

  it "should create user from google provider" do
    email = "test_user_#{@time_stamp}@google.com"
    provider_name = "google"
    payload = "{email:#{email},provider:#{provider_name}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata['status'].should == 'ok'
    user_id = pdata['entry']
    gresponse = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['entry']['active'].should be_true
    gdata['entry']['provider'].should == provider_name
  end

  it "should create user from facebook provider" do
    provider_name = "facebook"
    email = "test_user_#{@time_stamp}@#{provider_name}.com"

    payload = "{email:#{email},provider:#{provider_name}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    pdata = JSON.parse(response.body)
    pdata['status'].should == 'ok'
    user_id = pdata['entry']
    gresponse = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['entry']['active'].should be_true
    gdata['entry']['provider'].should == provider_name
  end

  it "should return an error for non supported provider (i.e. aol)" do
    
    email = "test_user_#{@time_stamp}@ign.com"
    expected_error_msg = 'Invalid argument provider'
    payload = "{email:#{email} ,provider:'aol'}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should == expected_error_msg
  end

  it "should return an error when provider field is empty" do
    
    email = "test_user_#{@time_stamp}@ign.com"
    expected_error_msg = 'Invalid argument provider'
    payload = "{email:#{email} ,provider:''}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should == expected_error_msg
  end

  it "should return an error when creating an user already exist" do

    email = "test_user_#{@time_stamp}_123@ign.com"
    expected_error_msg = 'Values cannot be stored in Users.create'

    payload = "{email:#{email},provider:'local'}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'ok'
    data['entry'].should_not be_empty

    eresponse = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    eresponse.code.should eql(200)
    edata = JSON.parse(eresponse.body)
    edata['status'].should == 'error'
    edata['entry'].should == expected_error_msg
  end

it "should return an error when email field is empty" do
    provider_name = 'google'
    email = "test_user_#{@time_stamp}@#{provider_name}.com"

    expected_error_msg = 'Values cannot be stored in Users.create'
    payload = "{email: '',provider:#{provider_name}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should == expected_error_msg
  end

it "should return an error using an malformed email" do
    provider_name = 'google'
    email = "test_user_#{@time_stamp}#{provider_name}.com"

    expected_error_msg = 'Values cannot be stored in Users.create'
    payload = "{email:#{email} ,provider:#{provider_name}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should == expected_error_msg
  end

  #Post - update existing user
  it "update an existing user in the system" do
    email = "test_user_#{@time_stamp}_456@google.com"
    provider_name = "google"

    #create account
    payload = "{email:#{email},provider:#{provider_name}}"
    cresponse = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    cresponse.code.should eql(200)
    cdata = JSON.parse(cresponse.body)
    cdata['status'].should == 'ok'
    user_id = cdata['entry']

    #update account
    mod_email = "test_user_#{@time_stamp}_456_mod@google.com"
    payload = "{email:#{mod_email}}"
    uresponse = RestClient.post "http://#{@config.options['baseurl']}/auth/user/#{user_id}", payload,{:content_type => 'application/json'}
    uresponse.code.should eql(200)
    udata = JSON.parse(uresponse.body)

    #check account is successfully updated
    gresponse = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{user_id}"
    gdata = JSON.parse(gresponse.body)
    gdata['entry']['active'].should be_true
    gdata['entry']['email'].should == mod_email
  end
end

