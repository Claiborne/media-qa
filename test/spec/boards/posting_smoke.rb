require 'rspec'
require 'selenium-webdriver'
require 'pathconfig'
require 'rest-client'
require 'json'
require 'boards_helper'; include BoardsHelper
require 'fe_checker'; include FeChecker
require 'widget-plus/global_header_nav'; include GlobalHeaderNav
require 'phantom_helpers/sign_in'; include SignIn

describe 'Boards - Smoke Test for Posting', :selenium => true do

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

  describe "Main Page" do

    context 'Global Header and Nav' do
      check_global_header_nav
      check_header_signed_in
    end

    context 'Main Section' do
      check_main_section_list
      check_main_section_links
    end

    context 'Sidebar Online Now Modules' do
      check_sidebar_online_now
    end

    context 'Sidebar Forum Stats' do
      check_sidebar_forum_stats
    end

    context 'Post New Thread' do

      it 'should open the My IGN topic index when clicked' do
        @selenium.find_element(:css => "ol.sectionMain").find_element(:link_text => "My IGN").click
        @selenium.find_element(:css => 'h1').text.should == 'My IGN'
        @selenium.current_url.match(/my-ign.80149/)
      end

      context 'Index Page for My IGN Topic' do
        it "should display the top 'post new thread' button " do
          @selenium.find_element(:css => "div.breadBoxTop a.callToAction[href*='my-ign.80149/create-thread']").displayed?.should be_true
          @selenium.find_element(:css => "div.breadBoxTop a.callToAction[href*='my-ign.80149/create-thread'] span").text.should == 'POST NEW THREAD'
        end

        it "should display the bottom 'post new thread' button " do
          @selenium.find_element(:css => "div.pageNavLinkGroup a.callToAction[href*='my-ign.80149/create-thread']").displayed?.should be_true
          @selenium.find_element(:css => "div.pageNavLinkGroup a.callToAction[href*='my-ign.80149/create-thread'] span").text.should == 'POST NEW THREAD'
        end

        it 'should open the new thread page when clicked' do
          @selenium.find_element(:css => "div.breadBoxTop a.callToAction[href*='my-ign.80149/create-thread']").click
          @wait.until {@selenium.find_element(:css => 'h1')}
          @selenium.find_element(:css => 'h1').text.should == 'Create Thread'
          @selenium.current_url.match(/my-ign.80149\/create-thread/)
        end

      context 'Create Thread Page' do

        it 'should type a title into the title field' do
          r = BoardsVar.set_var Random.rand(1000000000).to_s
          title = "QA Test #{r}"
          @selenium.find_element(:css => "input#ctrl_title_thread_create").send_keys title

        end

        it 'should type a body into the body field' do
          body = "Test body #{BoardsVar.get_var}"

          @selenium.switch_to.frame("ctrl_message_html_ifr")
          @selenium.find_element(:id => 'tinymce').send_keys body
          @selenium.switch_to.default_content
          sleep 1

        end

        it 'should create a thread when clicked' do
          @selenium.find_element(:css => 'input.primary.button').click
          @wait.until {@selenium.current_url.to_s.match(/threads\/qa-test-.../)}
          BoardsVar.set_url @selenium.current_url.to_s
        end

      end

      context 'View Thread Page' do

        it 'should display the correct title' do
          @selenium.find_element(:css => 'h1').text.should == "QA Test #{BoardsVar.get_var}"
        end

        it 'should display the correct body' do
          @selenium.find_element(:css => 'div.messageContent blockquote.messageText').text.should == "Test body #{BoardsVar.get_var}"
        end

      end

      context 'Index Page for My IGN Topic' do

        it 'should display the post' do
          @selenium.find_element(:css => "div.breadBoxTop a[href*='/forums/my-ign']").click
          @wait.until { @selenium.find_element(:link_text => "QA Test #{BoardsVar.get_var}") }
        end

      end

      end
    end

    context 'Clean Up / Delete' do

      it 'should prepare clean up' do
        @selenium.get "http://s.ign.com/signout"
      end

      sign_in('/boards/','williamjclaiborne@hotmail.com','gkastle')

      it 'should delete the post just created' do
        @selenium.get BoardsVar.get_url
        @selenium.find_element(:css => "a[class='item control delete OverlayTrigger']").click
        @wait.until { @selenium.find_element(:css => "div.xenOverlay input#ctrl_hard_delete") }
        @selenium.find_element(:css => "div.xenOverlay input#ctrl_hard_delete").click
        @selenium.find_element(:css => "dl.ctrlUnit.submitUnit input[value='Delete Post']").click
      end

      it 'should have deleted listing on the My IGN index page' do
        @wait.until { @selenium.current_url.to_s.match(/forums\/my-ign.../) }
        expect {  @selenium.find_element(:link_text => "QA Test #{BoardsVar.get_var}") }.to raise_error(Selenium::WebDriver::Error::NoSuchElementError)
      end

    end

  end
end
