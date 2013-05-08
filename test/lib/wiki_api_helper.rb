module WikiAPIHelper
  def basic_wiki_api_checks(data)
    check_200(@response)
    data['wikiId'].match(/^[0-9a-f]{24}$/).should be_true
    data['slug'].delete('^a-z').length.should > 0
    data['slug'].should_not be_nil
    data['status'].should == 'published'
    data['hidden'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['hidden'].to_s.should_not be_nil
    data['staff'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['staff'].to_s.should_not be_nil
    data['locked'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['locked'].to_s.should_not be_nil
    data['static'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['static'].to_s.should_not be_nil
    data['hasMap'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['hasMap'].to_s.should_not be_nil
    data['hasPokedex'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['hasPokedex'].to_s.should_not be_nil
    data['createdBy'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['createdBy'].to_s.should_not be_nil
    data['createdDate'].to_s.delete('^a-zA-Z0-9').length.should > 0
    data['createdDate'].to_s.should_not be_nil
  end
end

shared_examples "basic wiki API checks for each" do |count=0,start=0|

  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should return #{count} wikis" do
    @data['data'].count.should == count
  end

  it "should return 'count' data with a value of #{count}" do
    @data['count'].should == count
  end

  it "should return 'startIndex' data with a value of #{start}" do
    @data['startIndex'].should == start
  end

  it "should return 'endIndex' data with a value of #{count-1}" do
    @data['endIndex'].should == count-1+start
  end

  it "should return 'isMore' data with a value of 'true'" do
    @data['isMore'].should be_true
  end

  it "should have an 'wikiId' that is a 24-character hash for each wiki" do
    @data['data'].each do |w|
      w['wikiId'].match(/^[0-9a-f]{24}$/).should be_true
    end
  end

  it "should have a non-nil, non-blank 'slug' for each wiki" do
    @data['data'].each do |w|
      w['slug'].delete('^a-z').length.should > 0
      w['slug'].should_not be_nil
    end
  end

  it "should only return published wikis" do
    @data['data'].each do |w|
      w['status'].should == 'published'
    end
  end

  %w(hidden staff locked static hasMap hasPokedex createdBy createdDate).each do |field|
    it "should have a non-nil, non-blank '#{field}' for each wiki" do
      @data['data'].each do |w|
        w[field.to_s].to_s.delete('^a-zA-Z0-9').length.should > 0
        w[field.to_s].to_s.should_not be_nil
      end
    end end

  %w(wikiName mediawikiUrl).each do |field|
    it "should have a non-nil '#{field}' for each wiki", :stg => true do
      @data['data'].each do |w|
        w[field.to_s].to_s.should_not be_nil
      end
    end end

  %w(wikiName mediawikiUrl).each do |field|
    it "should have a non-nil '#{field}' for each wiki", :prd => true do
      @data['data'].each do |w|
        w[field.to_s].to_s.delete('^a-zA-Z0-9').length.should > 0
        w[field.to_s].to_s.should_not be_nil
      end
    end end

end

shared_examples "basic wiki API checks" do

  it "should return 200" do
    check_200(@response)
  end

  it "should not be blank" do
    check_not_blank(@data)
  end

  it "should have an 'wikiId' that is a 24-character hash" do
    @data['wikiId'].match(/^[0-9a-f]{24}$/).should be_true
  end

  it "should have a non-nil, non-blank 'slug'" do
    @data['slug'].delete('^a-z').length.should > 0
    @data['slug'].should_not be_nil
  end

  it "should only return a published wiki" do
    @data['status'].should == 'published'
  end

  %w(hidden staff locked static hasMap hasPokedex createdBy createdDate).each do |field|
  it "should have a non-nil, non-blank '#{field}'" do
    @data[field.to_s].to_s.delete('^a-zA-Z0-9').length.should > 0
    @data[field.to_s].to_s.should_not be_nil
  end end

  %w(wikiName mediawikiUrl).each do |field|
    it "should have a non-nil '#{field}'", :stg => true do
      @dataw[field.to_s].to_s.should_not be_nil
    end end

  %w(wikiName mediawikiUrl).each do |field|
  it "should have a non-nil '#{field}'", :prd => true do
    @data[field.to_s].to_s.delete('^a-zA-Z0-9').length.should > 0
    @data[field.to_s].to_s.should_not be_nil
  end end

end