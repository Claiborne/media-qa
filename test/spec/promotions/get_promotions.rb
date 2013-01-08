#require File.dirname(__FILE__) + "/../spec_helper"
require 'rspec'
require 'rest_client'
require 'json'
require 'configuration'
require 'rubygems'
require 'topaz_token'

include TopazToken

describe "rating_post" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../config/social.yml"
    @config = Configuration.new
    TopazToken.set_token('social')
  end

  before(:each) do

  end

  after(:each) do
  end
