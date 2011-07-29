require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "login local management" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/topaz_api.yml"
    @config = Configuration.new
    now = Time.now
    @time_stamp = now.strftime("%Y%m%d%H%M%S")
    @email = "test_user_#{@time_stamp}_#{Random.rand(100000-999999)}@ign.com"
    @password = "igntest@123"
    payload = "{email:#{@email},password:#{@password}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    local_data = JSON.parse(response.body)
    local_data['status'].should == 'ok'
    @local_user_id = local_data['entry']
    
  end

  before(:each) do
      #payload = "{loginCount:1}"
      #response = RestClient.post "http://#{@config.options['baseurl']}/auth/user/#{@local_user_id}", payload,{:content_type => 'application/json'}
      #response.code.should eql(200)
  end

  after(:each) do

  end

  #local
  it "should return login count incremented by 1" do
    response = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{@local_user_id}"
    data = JSON.parse(response.body)
    data['status'].should == 'ok'
    last_login_count = data['entry']['loginCount']

    payload = "{email:#{@email},password:#{@password}}"

    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'ok'
    data['entry']['loginCount'].should eql(last_login_count+1)
    
  end


  it "should return an error message when password is incorrect" do
    payload = "{email:#{@email},password:'12345'}"
    expected_error_msg = "Challenge failed for #{@email}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when password is missing" do
    payload = "{email:#{@email},password:''}"
    expected_error_msg = "Challenge failed for #{@email}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when email is missing" do
    payload = "{email:'',password:'igntest@123'}"
    expected_error_msg = "Challenge failed for "
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when email is malformed" do
    payload = "{email:#{@email.gsub(/@/,'')},password:'igntest@123'}"
    expected_error_msg = "Challenge failed for #{@email.gsub(/@/,'')}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end



  it "should return an error message when account is inactive" do
      payload = "{active:false}"
      response = RestClient.post "http://#{@config.options['baseurl']}/auth/user/#{@local_user_id}", payload,{:content_type => 'application/json'}
      response.code.should eql(200)
      
      payload = "{email:#{@email},password:#{@password}}"
      expected_error_msg = "The user #{@local_user_id} is disabled"
      response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/local", payload,{:content_type => 'application/json'}
      response.code.should eql(200)

      data = JSON.parse(response.body)
      data['status'].should == 'error'
      data['entry'].should eql(expected_error_msg)

  end

  #provider

end