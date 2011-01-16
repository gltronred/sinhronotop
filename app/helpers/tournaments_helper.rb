module TournamentsHelper
  def city(city)
    @tournament && @tournament.cities.include?(city)
  end
end
