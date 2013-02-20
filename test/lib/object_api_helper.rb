module ObjectApiHelper
  
  def get_game_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/games/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['gameId']
  end #end def
  
  def get_company_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/companies/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['companyId']
  end #end def
  
  def get_feature_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/features/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['featureId']
  end #end def
  
  def get_genre_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/genres/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['genreId']
  end #end def
  
  def get_hardware_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/hardware/slug/#{slug}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['hardwareId']
  end #end def
  
  def get_release_ids_by_legacy_id(legacy_id)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/releases/legacyId/#{legacy_id}"
    begin 
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    ids_array = []
    data['data'].each do |d|
      ids_array << d['releaseId']
    end
    ids_array
  end #end def
  
  def get_me3_uk_id
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/releases/legacyId/110694"
    begin
       response = RestClient.get url
    rescue => e
      raise Exception.new(e.message+" "+url+" "+e.response.to_s)
    end
    data = JSON.parse(response.body)
    data['data'].each do |d|
      if d['metadata']['region'] == "UK"; return d['releaseId']; end
    end
  end #end def

  def get_movie_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/movies/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['movieId'].to_s
  end #end def

  def get_movie_legacy_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/movies/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['metadata']['legacyId']
  end #end def

  def get_book_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/books/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['bookId'].to_s
  end #end def

  def get_volume_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/volumes/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['volumeId'].to_s
  end #end def

  def get_person_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/people/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['personId'].to_s
  end #end def

  def get_character_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/characters/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['characterId'].to_s
  end #end def

  def get_role_id(legacy_id)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/roles/legacyId/#{legacy_id}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    begin
    data['data'][0]['roleId'].to_s
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
  end #end def

  def get_roletype_id(slug)

    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/roleTypes/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['roleTypeId'].to_s
  end #end def

  def get_show_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/shows/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['showId'].to_s
  end #end def

  def get_season_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/seasons/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['seasonId'].to_s
  end #end def

  def get_episode_id(slug)
    PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = PathConfig.new
    url = "http://#{config.options['baseurl']}/episodes/slug/#{slug}"
    begin
      response = RestClient.get url
    rescue
      return "ERROR_IN_OBJ_API_HELPER"
    end
    data = JSON.parse(response.body)
    data['episodeId'].to_s
  end #end def

end

shared_examples "V3 Object API -- Create Object Without Review Data" do |object|
  describe '' do

    before(:all) do
      PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
      @config = PathConfig.new
      TopazToken.set_token('objects')
      @url = "http://apis.stg.ign.com/object/v3/#{object}?oauth_token=#{TopazToken.return_token}"
      begin
        @response = RestClient.post @url, create_valid_release_published, :content_type => "application/json"
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
      @data = JSON.parse(@response.body)
    end

    before(:each) do

    end

    after(:each) do

    end

    it "should return 200" do
      puts @data
      ObjectPostSearch.set_saved_id @data["#{object.downcase[0..-2]}Id"]
      ObjectPostSearch.append_id @data["#{object.downcase[0..-2]}Id"]
    end

    it "should not return scaledScore data" do
      begin
        response = RestClient.get "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
      data = JSON.parse(response.body)

      data.to_s.match(/scaledScore/).should be_false
    end

  end
end

shared_examples "V3 Object API -- Update Object With Score And Score System To Get Scaled Score" do |object|
  describe '' do

    before(:all) do
      PathConfig.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
      @config = PathConfig.new
      TopazToken.set_token('objects')
      @url = "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?oauth_token=#{TopazToken.return_token}"
      begin
        @response = RestClient.put @url, add_score_and_system_score_to_release, :content_type => "application/json"
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
      @data = JSON.parse(@response.body)
    end

    before(:each) do

    end

    after(:each) do

    end

    it "should return 200" do
    end

    it "should add a scaledScore of 0.85" do
      begin
        response = RestClient.get "http://apis.stg.ign.com/object/v3/#{object}/#{ObjectPostSearch.get_saved_id}?fresh=true"
      rescue => e
        raise Exception.new(e.message+" "+@url)
      end
      data = JSON.parse(response.body)

      data['network']['ign']['review']['scaledScore'].should == 0.85
    end
  end
end

