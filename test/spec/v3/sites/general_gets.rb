require 'rspec'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

include Assert

# GET /sites
# GET by /sites/beacons/www.ign.com
# GET by /categories/tags/xbox-360

describe "V3 Sites API -- GET /sites" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_sites.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/sites?fresh=true"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
    @prd_slugs = %w(emailpreferences-ign gamestats gamespy corp-ign m-ie-ign ign ie-ign crossassault-ign au-ign m-ign m-uk-ign m-au-ign m-ca-ign ca-ign uk-ign www-ign my-ign people-ign s-ign)
  end
  
  it "should return 200" do
    check_200 @response
  end
  
  it "should return 19 sites", :prd => true do
    @data.count.should == 19
  end
  
  it "should return at least one site", :stg => true do
    @data.count.should > 0
    check_not_blank @data[0]
    check_not_nil @data[0]
  end
  
  it "should return the appropriate sites (checking by slugs)", :prd => true do
    slugs = []
    @data.each do |s|
      slugs << s['slug']
    end
    slugs.should =~ @prd_slugs
  end
  
  it "should return a slug value", :stg => true do
    check_not_blank @data[0]['slug']
    check_not_nil @data[0]['slug']
  end
  
  it "should only return sites with an enabled value of true" do
    @data.each do |s|
      begin
        s['enabled'].should == true
      rescue => e
        raise e, "This site is not enabled:\n #{s}"
      end
    end
  end
  
  it "should return a urlSnippet value for each site" do
    @data.each do |s|
      check_not_blank s['urlSnippets'].to_s
      check_not_nil s['urlSnippets'].to_s
    end
  end
  
  %w(_id version lastUpdated).each do |key|
  it "should return a meta.#{key} value for each site" do
    @data.each do |s|
      check_not_blank s['meta'][key].to_s
      check_not_nil s['meta'][key].to_s
    end
  end end

end

describe "V3 Sites API -- GET by /sites/beacons/www.ign.com", :prd => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_sites.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/sites/beacons/www.ign.com?fresh=true"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end
  
  it "should return 200" do
    check_200 @response
  end
  
  {:slug => 'www-ign', :name => 'IGN US', :enabled => true, :urlSnippets => ['www.ign.com']}.each do |k,v|
  it "should return the appropriate #{k} value" do
    @data[k.to_s].should == v
  end end
  
  %w(adsense audience buyerbase chartbeat comscore ga).each do |beacon|
  it "should have the #{beacon} beacon enabled" do
    @data['beacons'][beacon]['enabled'].to_s.should == 'true'
  end end
  
  %w(cr exelate lighthouse linksmart).each do |beacon|
  it "should have the #{beacon} beacon disenabled" do
    @data['beacons'][beacon]['enabled'].to_s.should == 'false'
  end end
  
  %w(adsense audience linksmart chartbeat comscore ga exelate).each do |beacon|
  it "should return non-blank, non-nil attribute values for #{beacon}" do
    @data['beacons'][beacon]['attributes'].length.should > 0
    @data['beacons'][beacon]['attributes'].each do |attr|
      check_not_blank attr
      check_not_nil attr
    end
  end end
  
  it 'should return a meta._id value of 502575cba4278f4da84aa470' do
    @data['meta']['_id'].should == '502575cba4278f4da84aa470'
  end
  
  %w(version lastUpdated).each do |key|
  it "should return values for meta.#{key}" do
    check_not_blank @data['meta'][key].to_s
    check_not_nil @data['meta'][key].to_s
  end end
  
  it "should return the correct chartbeat.attributes.domain value" do
    @data['beacons']['chartbeat']['attributes']['domain'].should == 'ign.com'
  end
  
  it "should return the correct ga.attributes._setDomainName value" do
    @data['beacons']['ga']['attributes']['_setDomainName'].should == '.ign.com'
  end
end

describe "V3 Sites API -- GET by /categories/tags/xbox-360", :prd => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/v3_sites.yml"
    @config = PathConfig.new
    @url = "http://#{@config.options['baseurl']}/categories/tags/xbox-360?fresh=true"
    begin 
      @response = RestClient.get @url
    rescue => e
      raise Exception.new(e.message+" "+@url)
    end
    @data = JSON.parse(@response.body)
  end
  
  it "should return 200" do
    check_200 @response
  end
  
  it "should return at least three entires" do
    @data.count.should > 2
  end
  
  it "should return IGN Home, Other, and Tech" do
    site_names = []
    @data.each do |s|
      site_names << s['slug']
    end
    %w(ign-home ign-other tech).each do |x|
      site_names.include?(x).should be_true
    end
  end 
  
  it "should return only sites tagged xbox-360" do
    @data.each do |s|
      tags = []
      s['tags'].each do |tag|
        tags << tag['slug']   
      end
      begin
        tags.length.should > 0
        tags.include?('xbox-360').should be_true
      rescue => e
        raise e, e.message+"\n#{s['name']} returned the following tags: #{tags}" 
      end
    end
  end
  
end

