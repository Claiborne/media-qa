require 'uri'

class Page
 
  attr_accessor :client, :config
 
  @@errors = []

  def initialize(driver, config)
    @client = driver
    @config = config
  end

  def self.errors
    @@errors
  end

  def self.errors=(errors)
    @@errors = errors
  end

  def visit(url)
    @client.open(url)
  end
 
  def wait(timeout=30000)
    @client.wait_for_page_to_load timeout
  end

  def validate
    @client.is_element_present('html').should be_true
    @client.is_element_present('head').should be_true
    @client.is_element_presnet('body').should be_true
  end

  def assert_location(url)
    begin
      uri = URI.parse(@client.location)
      assert_equal url, [ uri.scheme, '://', uri.host, uri.path ].join 
    rescue Test::Unit::AssertionFailedError
      Page.errors << $!
    end
  end
  
  def assert test, msg = nil
    msg ||= "Failed assertion, no message given."
    unless test then
      msg = msg.call if Proc === msg
      raise Test::Unit::AssertionFailedError, msg
    end
    true
  end
      
  def assert_equal exp, act, msg = nil
    msg = message(msg) { "Expected #{exp}, not #{act}" }
    assert(exp == act, msg)
  end
  
  def message msg = nil, &default
    proc {
    if msg then
      msg = msg.to_s unless String === msg
      msg += '.' unless msg.empty?
      msg += "\n#{default.call}."
      msg.strip
      else
        "#{default.call}."
      end
    }
  end
  
  def assert_text(text)
    return @client.is_text_present(text)
  end
  
  def assert_element(element)
    return @client.is_element_present(element)
  end
  
  def click(element)
    @client.click(element)
  end
  
  def wait_for_element(element)
    @client.wait_for_element(element)
  end
 
end
