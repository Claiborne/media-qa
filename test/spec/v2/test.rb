require File.dirname(__FILE__) + "/../spec_helper"
require 'rest_client'
require 'json'
require 'configuration'
require 'Time'
require 'assert'

describe "tech channel blogroll" do #TODO defaults, category = Tech, blogroll keys

  include Assert

  before(:all) do

  end

  before(:each) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
    @config = Configuration.new
    
  end

  after(:each) do

  end

  it "should return articles with a category of tech", :stg => true do
  
    slug_tech = false

    response = RestClient.get "http://#{@config.options['baseurl']}/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc"
    data = JSON.parse(response.body)
    data.each do |article|
      article['categories'].each do |slug_value|
        puts slug_value['slug']
        if slug_value['slug'] == 'tech'
          slug_tech = true
        end
      end
    end 
    slug_tech.should be_true
  end
end