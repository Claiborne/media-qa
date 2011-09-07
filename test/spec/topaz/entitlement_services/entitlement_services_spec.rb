require File.dirname(__FILE__) + "/../../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'mongo'
require 'pp'

describe "Entitlement Services" do

  before(:all) do
    @ENTITLEMENTS = "entitlements"
    @APP_ID = "myign2"
    @USER_ID = "manish"
  end

  before(:each) do
    RestClient.log = '/tmp/myrestcalls.log'
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/entitlement_services.yml"
    @config = Configuration.new

    @conn = Mongo::Connection.new
    #@db = @conn.db('entitlements')
    #@db.drop_collection('entitlements')
  end

  after(:each) do

  end


  #get /appid/userid
  it "should return json response when providing valid app id and user id" do 
    today = Time.now
    puts "#{@APP_ID} -> #{@USER_ID}"
    #@db.collection('entitlements').insert({"_typeHint" => "domain.EntitlementData",:appId=> @APP_ID,:userId => @USER_ID,:entitlements => Hash["yearly","true"],:updated => today.to_s})
    response = RestClient.get "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}"
    response.code.should eql(200)
    data = JSON.parse(response.body)
  end

  it "should return a list of entitlements from specific appId and user id" do

    expected_list = Hash.new({:yearly => "true", :daily => "false",:monthly => "false"})
    #@db.collection('entitlements').insert({"some" => "thing","here" => "there"})
    response = RestClient.get "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}"
    response.code.should eql(200)

    data = JSON.parse(response.body)
    expected_list.each do |key,value|
      data[@ENTITLEMENTS].should have_key(key)
      data[@ENTITLEMENTS][key].should have_value(value)
    end
  end

  it "should return a specific subset of entitlements when providing filters" do
   
    filter_key = "yearly"
    expected_list = Hash.new( {filter_key => "true"})
    not_list = ['monthly', 'daily']
    #@db.collection('entitlements').insert({"some" => "thing","here" => "there"})
    response = RestClient.get "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}?fields=#{filter_key}"
    response.code.should eql(200)

    data = JSON.parse(response.body)
    expected_list.each do |key,value|
      data[@ENTITLEMENTS].should have_key(key)
      data[@ENTITLEMENTS][key].should have_value(value)
    end
    not_list.each do |item|
      data[@ENTITLEMENTS].should_not have_key(item)
    end
  end

  it "should return an error when providing invalid filters" do #should it return everything?
    response = RestClient.get( "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}?fields=something"){|response,request,result|
      response.code.should eql(200)
    }

  end


  it "should return an error when providing empty string for fields parameter" do #should it return everthying?
    response = RestClient.get( "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}?fields="){|response,request,result|
      response.code.should eql(200)
    }
  end

#post /appid/userid
  it "should add entries not existing in current entitlement list" do
    add = "{'userdefined' => 'true'}"
    response = RestClient.post "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}",{userdefined:'true'}
    response.code.should eql(200)
  end

  it "should update an entry that exist in entitlement list" do
    add = {'yearly' => 'false'}
    response = RestClient.post "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}",add,:content_type => 'application/json'
    response.code.should eql(200)

  end

  it "should return an error when no value is identified" do
    add = {}
    response = RestClient.post "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}",add,:content_type => 'application/json'
    response.code.should eql(200)

  end 

  it "should return an error when format of entries are not the correct format" do #xml format?
    add = "<xml><yearly>false</yearly></xml>"
    response = RestClient.post "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}",add,:content_type => 'application/json'
    response.code.should eql(200)
  end

#delete /appid/userid
  it "should delete a valid entry from the entitlement list" do
    response = RestClient.delete "http://#{@config.options['baseurl']}/#{@APP_ID}/#{@USER_ID}"
    response.code.should eql(200) 
  end

  it "should return an error when providing an invalid app id" do 
    response = RestClient.delete( "http://#{@config.options['baseurl']}/bogusname/tests"){|response,request,result|
      response.code.should eql(404)
    }
  end

  it "should return an error when providing a valid app id, but invalid user id" do
    response = RestClient.delete( "http://#{@config.options['baseurl']}/#{@APP_ID}/tests"){|response,request,result|
      response.code.should eql(404)
    }
  end

#get /config
  it "should return config info for the entitlements server" do 
    response = RestClient.get "http://#{@config.options['baseurl']}/config"
    response.code.should eql(200)
    data = JSON.parse(response.body)
    data.should have_key("mongoServer")
    data.should have_key("mode")
    data.should have_key("memcached")
  end


#put 
  it "should return an error stating put is not supported" do
    error_msg = "Use POST to create or update entitlement data. PUT is not supported"
    response = RestClient.put( "http://#{@config.options['baseurl']}/config",{}){|response,request,result|
      response.code.should eql(400)
      data = JSON.parse(response.body)
      data["error"].should eql(error_msg)
    }
  end

  it "should return an error when providing an valid app id and valid user id" do
    error_msg = "Use POST to create or update entitlement data. PUT is not supported"
    response = RestClient.put( "http://#{@config.options['baseurl']}/config",{}){|response,request,result|
      response.code.should eql(400)
      data = JSON.parse(response.body)
      data["error"].should eql(error_msg)
    }
  end
end
