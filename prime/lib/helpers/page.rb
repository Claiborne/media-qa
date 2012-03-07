require "rubygems"
gem "test-unit"
require "test/unit"
require "selenium-webdriver"
require "library"

class Page
	
  attr_accessor :client
     @@verification_errors = []
	
  def self.errors
     @@verification_errors
  end

  def self.errors=(errors)
     @@verification_errors = errors
  end

  def assert_text(text, xpath)
    begin
      if !@client.find_element(:xpath => xpath).text.include? text
        puts("FAIL: Could not locate text: #{text} Current URL: #{@client.get_location}\n")
        raise "#{text} not found"
      end
    rescue Test::Unit::AssertionFailedError
    end
    return true
  end
  
  def assert_action_true(assertion)
  	begin 
  		if !assertion
  			raise "assertion is false"
  		end
  	rescue Exception=>e
  		puts e
  	end
  end
  
  def assert_element(element)
    begin
      if !@client.is_element_present(element)
        puts("FAIL: Could not locate element: #{element} Current URL: #{@client.get_location}\n")
        raise "#{element} not found"
      end
    rescue Test::Unit::AssertionFailedError
    end
  end
  
  def assert_element_not_present(element)
    begin
      if @client.is_element_present(element)
        puts("FAIL: Successfully located element: #{element} Current URL: #{@client.get_location}\n")
        raise "#{element} was found"
      end
    rescue Test::Unit::AssertionFailedError 
    end
  end
  
  def key_press(element, key)
    @client.key_press element, key
  end
  
  def get_text(location, identifier)
  	case identifier
  	when "class"
  		return @client.find_element(:class, location).text
  	when "id"
  		return @client.find_element(:id, location).text
  	when "xpath"
  		return @client.find_element(:xpath, location).text
  	end    
  end
  
  def get_text_by_id(location)
  	return @client.find_element(:id, location).text
  end
  
  def locate_element(element)
    return @client.is_element_present(element)
  end
 
end