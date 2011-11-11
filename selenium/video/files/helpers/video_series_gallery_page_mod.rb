
module VideoSeriesGalleryPageMod

  def check_banner
	begin
		assert @selenium.is_element_present("css=div#series-banner a img[src*='http']"), "Unable to verify the banner is present with an image and link"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
end