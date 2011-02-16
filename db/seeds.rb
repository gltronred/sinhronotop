module SeedTasks
  def self.create_user(name, email, password, status=nil)
    user = User.find_by_email email
    unless user
      user = User.create(:name => name,
      :email => email,
      :password => password,
      :password_confirmation => password)
      if status
        user.status = status
        user.save!
      end
    end
  end
  
  def self.create_city(name)
    city = City.find_by_name name
    unless city
      city = City.create :name => name
    end
    city
  end
  
  def self.create_team(rating_id, name, city)
    team = Team.find_by_rating_id rating_id
    unless team
      team = Team.create(:name => name, :rating_id => rating_id, :city_id => city.id)
    end
    team
  end
  
  def self.create_calс_system(short_name, name)
    cs = CalcSystem.find_by_short_name short_name
    unless cs
      cs = CalcSystem.create(:short_name => short_name, :name => name)
    end
    cs
  end
  
  def self.create_event_status(short_name, name)
    es = EventStatus.find_by_short_name short_name
    unless es
      es = EventStatus.create(:short_name => short_name, :name => name)
    end
    es
  end
  
end


File.open(File.join(Rails.root, 'db', "teams.txt"), 'r') do |file|
  file.each_line do |line|
    atributes = line.split(';')
    rating_id, team_name, city_name = atributes[0], atributes[1], atributes[2]
    city = SeedTasks.create_city city_name
    SeedTasks.create_team(rating_id, team_name, city)
  end
end

SeedTasks.create_event_status("new", "новая")
SeedTasks.create_event_status("approved", "принята")
SeedTasks.create_event_status("denied", "отклонена")

SeedTasks.create_calс_system("mm", "микроматчи")
SeedTasks.create_calс_system("nn", "не знаю пока")
SeedTasks.create_calс_system("one_game", "турнир одноэтапный, считать не надо")

=begin
SeedTasks.create_city "Кёльн"
SeedTasks.create_city "Франкфурт"
SeedTasks.create_city "Берлин"
SeedTasks.create_city "Хемниц"
SeedTasks.create_city "Дортмунд"
SeedTasks.create_city "Кобленц"
SeedTasks.create_city "Нюрнберг"
SeedTasks.create_city "Штутгарт"
SeedTasks.create_city "Халле"
SeedTasks.create_city "Дюссельдорф"
SeedTasks.create_city "Мюнхен"
SeedTasks.create_city "Трир"
SeedTasks.create_city "Гамбург"
=end
SeedTasks.create_user("Михаил Перлин", ENV['GMAIL_SMTP_USER'], ENV['GMAIL_SMTP_PASSWORD'], 'admin')
SeedTasks.create_user("посетитель", "znatok@example.com", 'znatok','znatok')
