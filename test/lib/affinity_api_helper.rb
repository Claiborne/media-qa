module AffinityApiHelper

  def affinity_api_common_checks

    %w(Type Code Data ResponseTime).each do |data|
      it "should return #{data} data with a non-nil, non-blank value" do
        @data.has_key?(data).should be_true
        @data[data].should_not be_nil
        @data[data].to_s.delete('^a-zA-Z0-9').length.should > 0
      end
    end

    it "should return 'Type' data with a value of Success" do
      @data['Type'].should == 'Success'
    end

    it "should return 'Code' data with a value of 200" do
      @data['Code'].should == 200
    end

  end

  def affinity_api_response_time(time)

    it "should return a 'ResponseTime' value under 50" do
      @data['ResponseTime'].should < time
    end

  end









end