require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

describe "V3 Boards API -- General Gets -- /legacyId/:id" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_boards.yml"
    @config = PathConfig.new
    url = "http://#{@config.options['baseurl']}/boards?fresh=true"
    res = RestClient.get url
    d = JSON.parse(res.body)
    @legacy_ids = []
    d['data'][0]['relatedLegacyIds'].each do |b|
      @legacy_ids << b.to_i
    end
  end

  before(:each) do

  end

  after(:each) do

  end

  it "should set up the test case" do
    @legacy_ids.count.should > 20
  end

  it "should get a board by xenforoId" do
    @legacy_ids.each do |id|
      url = "http://#{@config.options['baseurl']}/boards/legacyId/#{id}?fresh=true"
      begin
        res = RestClient.get url
      rescue => e
        raise Exception.new(e.message+" "+url+" "+id.to_s)
      end
      data = JSON.parse(res.body)
      check_200(res)
      check_not_blank(data)
      data['data'].each do |b|
        b['xenforoId'].to_i.should > -1
        b['primaryLegacyId'].should be_true
        @legacy_ids.include? b['relatedLegacyIds'].should be_true
        b['_id'].match(/^[0-9a-f]{24}$/).should be_true
      end
    end
  end

end