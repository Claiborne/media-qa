require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'phantom_helpers/sign_in'; include SignIn

describe 'Boards - Messaging', :selenium => true do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../config/boards.yml"
    @config = PathConfig.new
    BrowserConfig.browser_path = File.dirname(__FILE__) + "/../../config/browser.yml"
    @browser_config = BrowserConfig.new

    @base_url = "http://#{@config.options['baseurl']}"

    @selenium = Selenium::WebDriver.for @browser_config.options['browser'].to_sym
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  end

  after(:all) do
    @selenium.quit
  end

  before(:each) do

  end

  after(:each) do

  end

  context 'Sign In' do
    sign_in('/boards/')
  end

  describe 'Send Message' do

    context 'Main Page' do

      it "should open the message page when 'Inbox is clicked'" do
        @selenium.find_element(:css => 'div.mainNavigation span.inbox a.navLink').click
        @selenium.find_element(:css => 'div.mainNavigation span.inbox a.navLink').click
        @wait.until { @selenium.find_element(:css => 'h1').text == 'Conversations' }
      end

    end

    context 'Message Index Page' do

      it "should open the new message page when 'Start a New Conversation' is clicked" do
        @selenium.find_element(:css => 'div.breadBoxTop div.topCtrl a').click
        @wait.until { @selenium.find_element(:css => 'h1').text == 'Start a New Conversation' }
      end

    end

    context 'New Message Page' do

      it "should type the recipient's name" do
        @selenium.find_element(:css => "input[name='recipients']").send_keys 'm_qa'
      end

      it 'should type the title' do
        i = BoardsVar.set_var Random.rand(1000000000).to_s
        @selenium.find_element(:css => "input[name='title']").send_keys "Hello there #{i}"
      end

      it 'should type the body' do
        body = "Test message body #{BoardsVar.get_var}"
        @selenium.switch_to.frame("ctrl_message_html_ifr")
        @selenium.find_element(:id => 'tinymce').send_keys body
        @selenium.switch_to.default_content
        sleep 1
      end

      it 'should create a new message when clicked' do
        @selenium.find_element(:css => "input[value='Start a Conversation']").click
        @wait.until { @selenium.find_element(:css => 'h1').text == "Hello there #{BoardsVar.get_var}" }
      end

      it 'should sign out' do
        @selenium.get "http://s.ign.com/signout"
      end

    end

  end

  describe 'Receive Message' do

    context 'Sign In' do
      sign_in('/boards/', 'qatest@testign.com', 'testpassword')
    end

    context 'Main Page' do

      it 'should display one new alert in the boards header' do
        @selenium.find_element(:css => 'div.mainNavigation span.navTab.inbox span.Total').text.to_i.should == 1
      end

      it 'should clear alerts' do
        @selenium.action.move_to(@selenium.find_element :css => 'div.mainNavigation span.navTab.alerts a').perform
      end

      it "should open the message page when 'Inbox is clicked'" do
        @selenium.get @selenium.find_element(:css => 'div.mainNavigation span.inbox a.navLink').attribute('href').to_s
        @wait.until { @selenium.find_element(:css => 'h1').text == 'Conversations' }
      end

    end

    context 'Message Index Page' do

      it "should display the message just send" do
        @selenium.find_element(:css => 'ol.discussionListItems li h3 a').text.should == "Hello there #{BoardsVar.get_var}"
      end

      it "should open the message when clicked" do
        @selenium.find_element(:css => 'ol.discussionListItems li h3 a').click
        @wait.until { @selenium.find_element(:css => 'h1').text == "Hello there #{BoardsVar.get_var}" }
      end

    end

    context 'New Message Page' do

      it 'should display the message title' do
        #verified above
      end

      it 'should display the message body' do
        @selenium.find_element(:css => 'div.messageInfo blockquote.messageText')
      end

      it "should display the sender's avatar image" do
        img = "http://oystatic.ignimgs.com/src/core/img/social/avatars/system/baseball.jpg"
        @selenium.find_element(:css => 'div.messageUserInfo div.avatarHolder img').attribute('src').should == img
        RestClient.get img
      end

    end

  end

end