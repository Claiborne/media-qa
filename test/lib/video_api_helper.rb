module VideoApiHelper

  def get_videos_by_state(state)
    {
        "matchRule"=>"matchAll",
        "rules"=>[
        ],
        "startIndex"=>0,
        "count"=>200,
        "networks"=>"ign",
        "prime"=>"false",
        "states"=>state
    }.to_json
  end

  def get_playlists_by_state(state)
    {
        "matchRule"=>"matchAll",
        "rules"=>[
        ],
        "startIndex"=>0,
        "count"=>75,
        "states"=>state
    }.to_json
  end

end


