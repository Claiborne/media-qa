require "test/unit/assertions"
gem "selenium-client"
require "selenium/client"

class Page

  attr_accessor :client
     @@verification_errors = []

  def self.errors
     @@verification_errors
  end

  def self.errors=(errors)
     @@verification_errors = errors
  end
  
  def visit(url)
    @client.open(url)
  end   

  def assert_text(text)
    begin
      if !@client.is_text_present(text)
        puts("FAIL: Could not locate text: #{text} Current URL: #{@client.get_location}\n")
        raise "#{text} not found"
      end
    rescue Test::Unit::AssertionFailedError
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
  
  def locate_text(text)
    return @client.is_text_present(text)
  end
  
  def locate_element(element)
    return @client.is_element_present(element)
  end
 
end