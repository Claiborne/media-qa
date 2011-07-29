require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'

describe "login facebook provider management" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/topaz_api.yml"
    @config = Configuration.new

    now = Time.now
    @time_stamp = now.strftime("%Y%m%d%H%M%S")

    @provider = 'facebook'
    @email = "test_user_#{@time_stamp}_#{Random.rand(100000-999999)}@#{@provider}.com"
    @password = "igntest@123"
    payload = "{email:#{@email},provider:#{@provider}}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/user", payload,{:content_type => 'application/json'}
    response.code.should eql(200)
    local_data = JSON.parse(response.body)
    local_data['status'].should == 'ok'
    @provider_user_id = local_data['entry']

  end

  before(:each) do

  end

  after(:each) do

  end

  #local
  it "should return login count incremented by 1" do
    response = RestClient.get "http://#{@config.options['baseurl']}/auth/user/#{@provider_user_id}"
    data = JSON.parse(response.body)
    data['status'].should == 'ok'
    last_login_count = data['entry']['loginCount']
    

    payload = "{email:#{@email},provider:#{@provider}}"

    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'ok'
    data['entry']['loginCount'].should eql(last_login_count+1)

  end

  it "should return an error message when provider is incorrect" do
    payload = "{email:#{@email},provider: 'local'}"
    expected_error_msg = "Challenge failed for #{@email}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when provider is missing" do
    payload = "{email:#{@email},provider:''}"
    expected_error_msg = "No enum const class models.ProviderEnum."
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when email is missing" do
    payload = "{email:'',provider: #{@provider}}"

    expected_error_msg = "Challenge failed for "
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)

  end

  it "should return an error message when email is malformed" do
    malformed_email = @email.gsub(/@/,'')
    payload = "{email:#{malformed_email},provider:#{@provider}}"
    expected_error_msg = "Challenge failed for #{malformed_email}"
    response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
    response.code.should eql(200)

    data = JSON.parse(response.body)
    data['status'].should == 'error'
    data['entry'].should eql(expected_error_msg)
  end



  it "should return an error message when account is inactive" do
      payload = "{active:false}"
      response = RestClient.post "http://#{@config.options['baseurl']}/auth/user/#{@provider_user_id}", payload,{:content_type => 'application/json'}
      response.code.should eql(200)

      payload = "{email:#{@email},provider:#{@provider}}"
      expected_error_msg = "The user #{@provider_user_id} is disabled"
      response = RestClient.post "http://#{@config.options['baseurl']}/auth/login/provider", payload,{:content_type => 'application/json'}
      response.code.should eql(200)

      data = JSON.parse(response.body)
      data['status'].should == 'error'
      data['entry'].should eql(expected_error_msg)

  end

  #provider

end