module TournamentsHelper
  def city(city)
    @tournament && @tournament.cities.include?(city)
  end

  def get_tag(tag)
    @tournament && @tournament.tags.include?(tag)
  end

end
