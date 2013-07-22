require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Boards API -- General Gets -- /xenforoId/:id" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    url = "http://#{@config.options['baseurl']}/boards?count=25&fresh=true"
    res = RestClient.get url
    d = JSON.parse(res.body)
    @xenforo_ids = []
    d['data'].each do |b|
      @xenforo_ids << b['xenforoId'].to_i
    end
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should set up the test case" do
    @xenforo_ids.count.should == 25
  end

  it "should get a board by xenforoId" do
    @xenforo_ids.each do |id|
      url = "http://#{@config.options['baseurl']}/boards/xenforoId/#{id}?fresh=true"
      begin
      res = RestClient.get url
      rescue => e
        raise Exception.new(e.message+" "+url+" "+id.to_s)
      end
      data = JSON.parse(res.body)
      check_200(res)
      check_not_blank(data)
      data['xenforoId'].should == id
      data['primaryLegacyId'].should be_true
      data['relatedLegacyIds'].should be_true
      data['_id'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

end