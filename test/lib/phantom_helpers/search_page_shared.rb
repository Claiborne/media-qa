
shared_examples "search item link checker" do
  it "should only contain links that 200", :spam => true do
    @selenium.find_elements(:css => 'div#search-list div.search-item a').count.should > 10
    @selenium.find_elements(:css => 'div#search-list div.search-item a').each do |link|
      rest_client_not_301_home_open link.attribute('href').to_s unless link.attribute('href').to_s.match(/com\/images/)
    end
  end
end
