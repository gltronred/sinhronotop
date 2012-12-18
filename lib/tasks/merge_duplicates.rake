namespace :db do
  task :merge_duplicates => :environment do
    teams_no_rating = Team.find(:all, :conditions => "rating_id is null or rating_id < 0")
    teams_no_rating.each do |t|
      if t.city
        team_with_rating = Team.find(:first, :conditions => ["rating_id is not null and rating_id > 0 and LOWER(name) = LOWER(?)", t.name.strip])
        if team_with_rating
          Team.merge(team_with_rating, t)
          puts "Eliminated #{team_with_rating}"
        end
      end
    end
  end
end