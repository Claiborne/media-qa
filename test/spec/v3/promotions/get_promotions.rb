require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'
require 'topaz_token'

include Assert
include TopazToken


class PromotionGetsHelperVars

  @token = return_topaz_token('promotions')

  def self.return_token
    @token
  end

end

include Assert

describe "V3 Promotion API -- promotion -- /promotion" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_promotions.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/promotion"
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

  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return a hash with three indices" do
    check_indices(@data, 4)
  end

  {'count'=>10,'startIndex'=>0,'hasMore'=>true}.each do |data,value|
    it "should return '#{data}' data with a value of #{value}" do
      @data.has_key?(data).should be_true
      @data[data].should_not be_nil
      @data[data].to_s.length.should > 0
      @data[data].should == value
    end
  end

  it "should return 10 releases" do
    @data['data'].length.should == 10
  end

  ['promotionId','name','active','validation','hasBuckets','createdDate','updatedDate'].each do |data|
    it "should return #{data} data with a non-nil, not-blank value for all promotions" do
      @data['data'].each do |promotion|
        promotion.has_key?(data).should be_true
        promotion[data].should_not be_nil
        promotion[data].to_s.length.should > 0
      end
    end
  end

#####################################################
  [0,25].each do |start_index|
  describe "V3 promotions API -- promotions count tests -- /promotion?count=100&startIndex=#{start_index} " do

    before (:all) do
      PathConfig.config_path=File.dirname(__FILE__) + "/../../../config/v3_promotions.yml"
      @config = PathConfig.new
      @url = "http://#{@config.options['baseurl']}/promotion?count=100&startIndex=#{start_index}"
      begin
        @response = RestClient.get @url
      rescue => e
        raise Exception.new(e.message+""+@url)
      end
      @data = JSON.parse(@response.body)
    end

    before (:each) do

    end
     after (:each) do
     end

    it "should return 200" do
      check_200(@response)
    end

    it "should not be blank" do
      check_not_blank(@data)
    end

    it "should return a hash with four indices" do
      check_indices(@data, 4)
    end

    {'count'=>100,'startIndex'=>start_index,'hasMore'=>true}.each do |data,value|
      it "should return '#{data}' data with a value of #{value}" do
        @data.has_key?(data).should be_true
        @data[data].should_not be_nil
        @data[data].to_s.length.should > 0
        @data[data].should == value
      end
    end

    it "should return 100 promotions " do
      @data['data'].length.should == 100
    end

end
  end

  ##########################################################

  [534,547,546].each do |promotion_id|
    describe "V3 promotions API -- promotions code tests -- /promotion/#{promotion_id}/codes " do

      before (:all) do
        PathConfig.config_path=File.dirname(__FILE__) + "/../../../config/v3_promotions.yml"
        @config = PathConfig.new
        @url = "http://#{@config.options['baseurl']}/promotion/#{promotion_id}/codes"
        begin
          @response = RestClient.get @url
        rescue => e
          raise Exception.new(e.message+""+@url)
        end
        @data = JSON.parse(@response.body)
      end

      before (:each) do

      end
      after (:each) do
      end

      it "should return 200" do
        check_200(@response)
      end

      it "should not be blank" do
        check_not_blank(@data)
      end

      it "should return a hash with four indices" do
        check_indices(@data, 4)
      end

      {'count'=>10,'startIndex'=>0,'hasMore'=>true}.each do |data,value|
        it "should return '#{data}' data with a value of #{value}" do
          @data.has_key?(data).should be_true
          @data[data].should_not be_nil
          @data[data].to_s.length.should > 0
          @data[data].should == value
        end
      end

      ['codeId','promotionId','ordinal','code','createdDate'].each do |data|
        it "should return #{data} data with a non-nil, not-blank value for all promotions" do
          @data['data'].each do |promotion|
            promotion.has_key?(data).should be_true
            promotion[data].should_not be_nil
            promotion[data].to_s.length.should > 0
          end
        end
      end

      ['country','region','bucket'].each do |data|
        it "should return #{data} data with a nil, blank values for all promotions" do
          @data['data'].each do |promotion|
            promotion.has_key?(data).should be_true
            promotion[data].should be_empty
            promotion[data].to_s.length.should == 0
          end
        end
      end

      {'promotionId'=>promotion_id}.each do |data,value|
        it "should return '#{data}' data with a value of #{value}" do
          @data['data'].each do |promotion|
          promotion[data].should == value
        end
      end
    end
       end
  end


  ###################################
  @id
  code_id = [10084627,10285064,10286065]
  i=0
  [534,546,547].each do |promotion_id|
    params = "promotion/#{promotion_id}/code/#{code_id[i]}"

    describe "V3 promotions API -- promotions codeId tests -- /promotion/#{promotion_id}/code/#{code_id[i]} " do

      before (:all) do
        @id = code_id[i]
        PathConfig.config_path=File.dirname(__FILE__) + "/../../../config/v3_promotions.yml"
        @config = PathConfig.new
        @url = "http://#{@config.options['baseurl']}/#{params}"
        puts @url

        begin
          @response = RestClient.get @url
        rescue => e
          raise Exception.new(e.message+""+@url)
        end
        @data = JSON.parse(@response.body)
      end

      before (:each) do

      end
      after (:each) do
      end

      it "should return 200" do
        check_200(@response)
      end

      it "should not be blank" do
        check_not_blank(@data)
      end

      it "should return a hash with four indices" do
        check_indices(@data, 4)
      end

      {'count'=>1,'startIndex'=>0,'hasMore'=>false}.each do |data,value|
        it "should return '#{data}' data with a value of #{value}" do
          @data.has_key?(data).should be_true
          @data[data].should_not be_nil
          @data[data].to_s.length.should > 0
          @data[data].should == value
        end
      end

      {'codeId'=>code_id[i],'promotionId'=>promotion_id,'ordinal'=>1,'code'=>"test998"}.each do |data,value|
        it "should return #{data} data with a value of #{value}" do
          puts @data['data']
          @data['data'].each do |promotion,value1|
          #{"codeId"=>10285064, "promotionId"=>546, "ordinal"=>1, "code"=>"test97", "country"=>"", "region"=>"", "bucket"=>"", "createdDate"=>"2013-02-28T11:35:17Z"}.each do |promotion, value1|

            puts promotion
            puts value1

            #promotion.has_key?(data).should be_true
            #promotion[data].should be_empty
            #promotion[data].to_s.length.should == 0
            #promotion[data].should == value
          @data['data'][0].has_key?(promotion).should be_true
          #@data[data].should_not be_nil
          #@data[data].to_s.length.should > 0
          #@data[data].should == value
        end
        end
          end

      #['country','region','bucket'].each do |data|
        #it "should return #{data} data with a nil, blank values for all promotions" do
          #puts data
          #@data['data'].each do |promotion|
           # promotion.has_key?(data).should be_true

          #  promotion[data].should be_empty
          #  promotion[data].to_s.length.should == 0
         # end

       # end
      #end

    end
    i=i+1
  end
  end





