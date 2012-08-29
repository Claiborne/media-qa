module ObjectApiHelper
  
  def get_game_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
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
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/movies/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['movieId'].to_s
  end #end def

  def get_movie_legacy_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/movies/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['metadata']['legacyId']
  end #end def

  def get_book_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/books/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['bookId'].to_s
  end #end def

  def get_volume_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/volumes/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['volumeId'].to_s
  end #end def

  def get_person_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/people/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['personId'].to_s
  end #end def

  def get_character_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/characters/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['characterId'].to_s
  end #end def

  def get_role_id(legacy_id)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/roles/legacyId/#{legacy_id}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['roleId'].to_s
  end #end def

  def get_roletype_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/roleTypes/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['roleTypeId'].to_s
  end #end def

  def get_show_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/shows/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['showId'].to_s
  end #end def

  def get_season_id(slug)
    Configuration.config_path = File.dirname(__FILE__) + "/../config/v3_object.yml"
    config = Configuration.new
    url = "http://#{config.options['baseurl']}/seasons/slug/#{slug}"
    response = RestClient.get url
    data = JSON.parse(response.body)
    data['seasonId'].to_s
  end #end def

end