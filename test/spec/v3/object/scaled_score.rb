require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'object_post_search'; include ObjectPostSearch
require 'object_api_helper'
require 'topaz_token'

include Assert
include TopazToken

describe "V3 Object API -- Get Search For ScaledScore I", :test => true do

  before(:all) do
    search_body = {:rules=> [{
                  :field=>"network.ign.review.score",
                  :condition=>"exists",
                  :value=>""}],
                  :matchRule=>"matchAll",
                  :startIndex=>100,
                  :count=>200,
                  :sortBy=>"network.ign.review.scaledScore",
                  :sortOrder=>"desc",
                  }.to_json
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{search_body}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should return 200 releases' do
    @data['data'].count.should == 200
  end

  it 'should return scaledScore data for each release' do
    @data['data'].each do |r|
      r['network']['ign']['review']['scaledScore'].to_s.match(/[0-9]/).should be_true
    end
  end

  it 'should return scaledScore value no more than two decimal places' do
    @data['data'].each do |r|
      r['network']['ign']['review']['scaledScore'].to_s.delete('^0-9').length.should < 4
    end
  end

  it 'should return releases sorted descending by scaledScore' do
    scaled_score = []
    @data['data'].each do |r|
      scaled_score << r['network']['ign']['review']['scaledScore']
    end
    scaled_score.should == scaled_score.sort {|x,y| y <=> x }
  end


end

describe "V3 Object API -- Get Search For ScaledScore II", :test => true do

  before(:all) do
    search_body = {:rules=> [{
                   :field=>"network.ign.review.scaledScore",
                   :condition=>"exists",
                   :value=>""},{
                   :field=>"network.ign.review.scaledScore",
                   :condition=>"range",
                   :value=>"0.8,0.9"}],
                   :matchRule=>"matchAll",
                   :startIndex=>0,
                   :count=>200,
                   :sortBy=>"network.ign.review.scaledScore",
                   :sortOrder=>"desc",
    }.to_json
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://#{@config.options['baseurl']}/releases/search?q=#{search_body}"
    @url = @url.gsub(/\"|\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
    begin
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it 'should return 200 releases' do
    @data['data'].count.should == 200
  end

  it 'should return releases with scaledScore values within the asked-for range' do
    @data['data'].each do |r|
      (0.9 >= r['network']['ign']['review']['scaledScore']).should be_true
      (r['network']['ign']['review']['scaledScore'] >= 0.8).should be_true

    end
  end

  it 'should return scaledScore value no more than two decimal places' do
    @data['data'].each do |r|
      r['network']['ign']['review']['scaledScore'].to_s.delete('^0-9').length.should > 0
      r['network']['ign']['review']['scaledScore'].to_s.delete('^0-9').length.should < 4
    end
  end

  it 'should return releases sorted descending by scaledScore' do
    scaled_score = []
    @data['data'].each do |r|
      scaled_score << r['network']['ign']['review']['scaledScore']
    end
    scaled_score.should == scaled_score.sort
  end

end

############################### CREATE AND UPDATE FLOWS ###############################

{:Release=>'releases', :Show=>'shows', :Episode=>'episodes', :Volume=>'volumes'}.each do |object_name, object|
describe "V3 Object API -- Create #{object_name} With Review Data", :test => true, :stg => true do

  before(:all) do
    ObjectPostSearch.blank_saved_ids
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/#{object}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.post @url, create_valid_release_w_review, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
    puts @data
    ObjectPostSearch.set_saved_id @data["#{object.downcase[0..-2]}Id"]
    ObjectPostSearch.append_id @data["#{object.downcase[0..-2]}Id"]
  end

  it "should return correct scaledScore data" do
    url = "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
    begin
      response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.85

  end

end

############################### NEW FLOW ###############################

describe "V3 Object API -- Create #{object_name} Without Review Data", :test => true, :stg => true do
  include_examples "V3 Object API -- Create Object Without Review Data", object
end

describe "V3 Object API -- Add scaledScore data directly", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, add_scaled_score, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should should fail" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data.to_s.match(/scaledScore/).should be_false
  end

end

describe "V3 Object API -- Update Object With Score And Score System To Get Scaled Score", :test => true, :stg => true do
  include_examples "V3 Object API -- Update Object With Score And Score System To Get Scaled Score", object
end

describe "V3 Object API -- Update #{object_name} With Custom Scaled Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, add_scaled_score, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should fail" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review']['scaledScore'].should == 0.85
  end

end

describe "V3 Object API -- Update #{object_name} to Remove Review Score", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
    @url = "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
    begin
      @response = RestClient.put @url, remove_review_from_release, :content_type => "application/json"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should return 200" do
  end

  it "should delete scaledScore data" do
    begin
      response = RestClient.get "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    data = JSON.parse(response.body)

    data['network']['ign']['review'].to_json.should == {:system=>'ign-games'}.to_json
  end

end

############################### NEW FLOW ###############################

describe "V3 Object API -- Create #{object_name} Without Review Data", :test => true, :stg => true do
  include_examples "V3 Object API -- Create Object Without Review Data", object
end

describe "V3 Object API -- Update Object With Score And Score System To Get Scaled Score", :test => true, :stg => true do
  include_examples "V3 Object API -- Update Object With Score And Score System To Get Scaled Score", object
end

describe "V3 Object API -- Clean Up", :test => true, :stg => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_object.yml"
    @config = PathConfig.new
    TopazToken.set_token('objects')
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should clean up and return 200" do
    raise Exception, 'v3/object/scaled_score.rb did not perform clean up' unless ObjectPostSearch.get_ids.length > 0
    ObjectPostSearch.get_ids.each do |id|
      @url = "http://apis.stg.ign.com/object/v3/#{object}/#{id}?oauth_token=#{TopazToken.return_token}"
      begin
        @response = RestClient.delete @url
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
    end
  end

end
end