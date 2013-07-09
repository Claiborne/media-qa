class SlotterAPIHelper
  class << self
    attr_accessor :id, :content_id, :version_id
  
    def create_slotter_content
      {
        :name => 'Media QA Test',
        :description => 'Media QA Automated Testing',
        :items => [
        {
          :url => 'test url',
          :images => [
            {:url => 'test image1'},
            {:url => 'test image2'}
            ],
            :description => 'test description',
            :title => 'test title',
            :caption => 'test caption'
          },
        {
          :url => 'test url',
          :images => [
            {:url => 'test image1'},
            {:url => 'test image2'}
            ],
            :description => 'test description',
            :title => 'test title',
            :caption => 'test caption'
          }
        ]
      }.to_json
    end
  end
end

shared_examples "check content" do

  it "should return 200" do
    @response.code.should == 200
  end 

  it "should return the correct metaId value" do
    @data['metaId'].should == SlotterAPIHelper.content_id
  end

  it "should return the correct versionId value" do
    @data['versionId'].should == SlotterAPIHelper.version_id
  end

  it "should return a timestamp not more than 5 minutes from current time" do
    time_diff = Time.now - Time.parse(@data['timestamp'])
    time_diff.abs.should < 60*5
  end

  {:name => 'Media QA Test', :description => 'Media QA Automated Testing'}.each do |k,v|
  it "should return the correct version.#{k} value" do
    @data[k.to_s].should == v
  end; end

  {:title => 'test title', :description => 'test description', :url => 'test url', :caption => 'test caption'}.each do |k,v|
  it "should return the correct version.items.#{k} value" do
    @items.each do |i|
      i[k.to_s].should == v
    end
  end; end

  it "should return the correct version.items.images values" do
    @items.each do |i| 
      i['images'].should == [{"url"=>"test image1", "caption"=>"", "qualifier"=>""},{"url"=>"test image2", "caption"=>"", "qualifier"=>""}]
    end 
  end

end