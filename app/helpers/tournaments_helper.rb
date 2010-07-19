module TournamentsHelper
  def city(i)
        if @tournament
           @tournament.cities.include?(i)
        else
          false
        end
     end
end
