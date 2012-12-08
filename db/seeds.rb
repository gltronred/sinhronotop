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
  
  def self.create_city(rating_id, name, province, country, time_shift, time_zone)
    city = City.find_by_name name
    unless city
      city = City.create(:rating_id => rating_id, :name => name, :province => province, :country => country, :time_shift => time_shift, :time_zone => time_zone)
    else
      city.update_attributes(:rating_id => rating_id, :name => name, :province => province, :country => country, :time_shift => time_shift, :time_zone => time_zone)
    end
    city
  end
  
  def self.create_team(rating_id, name, city_name)
    team = Team.find_by_rating_id rating_id
    unless team
      city = City.find_by_name city_name
      team = Team.create(:name => name, :rating_id => rating_id, :city_id => city.id) if city
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

  def self.create_tag(short_name, name)
    t = Tag.find_by_short_name short_name
    unless t
      t = Tag.create(:short_name => short_name, :name => name)
    end
    t
  end
    
  def self.create_event_status(short_name, name)
    es = EventStatus.find_by_short_name short_name
    unless es
      es = EventStatus.create(:short_name => short_name, :name => name)
    end
    es
  end

  def self.create_payer(first_name, last_name, patronymic, rating_id)
    player = Player.find_by_rating_id(rating_id)
    unless player
      player = Player.create(:firstName => first_name, :lastName => last_name, :patronymic => patronymic, :rating_id => rating_id)
    end
    player
  end

  def self.set_player_team(team_id, player_id)
    player = Player.find_by_rating_id(player_id)
    team = Team.find_by_rating_id(team_id)
    player.update_attributes(:team_id => team.id) if player && team
  end

end

#how to encode
#conv -f CP1252 -t UTF-8 p.csv >> pn.csv
#http://www.artlebedev.ru/tools/decoder/

=begin
File.open(File.join(Rails.root, 'db', "cities.csv"), 'r') do |file|
  file.each_line do |line|
    atributes = line.split(';')
    rating_id, city_name, province, country, time_shift, time_zone = atributes[0], atributes[1], atributes[2], atributes[3], atributes[4], atributes[5]
    city = SeedTasks.create_city(rating_id, city_name, province, country, time_shift, time_zone)
  end
end
=end

=begin
File.open(File.join(Rails.root, 'db', "teams.csv"), 'r') do |file|
  file.each_line do |line|
    atributes = line.split(';')
    rating_id, team_name, city_name = atributes[0], atributes[1], atributes[2]
    city = City.find_by_name city_name
    SeedTasks.create_team(rating_id, team_name, city) if city
  end
end
=end

File.open(File.join(Rails.root, 'db', "players.csv"), 'r') do |file|
  file.each_line do |line|
    atributes = line.split(';')
    rating_id, last_name, first_name, patronymic = atributes[0], atributes[1], atributes[2], atributes[3]
    player = SeedTasks.create_payer(first_name, last_name, patronymic, rating_id)
  end
end

File.open(File.join(Rails.root, 'db', "players_with_teams.csv"), 'r') do |file|
  Player.update_all(:team_id => nil)
  file.each_line do |line|
    atributes = line.split(';')
    SeedTasks.create_team(atributes[0], atributes[1], atributes[2])
    SeedTasks.set_player_team(atributes[0], atributes[3])
  end
end

=begin

SeedTasks.create_tag("school", "школьники")
SeedTasks.create_tag("uni", "студенты")

SeedTasks.create_event_status("new", "новая")
SeedTasks.create_event_status("approved", "принята")
SeedTasks.create_event_status("denied", "отклонена")

SeedTasks.create_calс_system("mm", "микроматчи")
SeedTasks.create_calс_system("sl", "формула Сибирской лиги")
SeedTasks.create_calс_system("nn", "не знаю пока")
SeedTasks.create_calс_system("one_game", "турнир одноэтапный, считать не надо")

SeedTasks.create_user("Михаил Перлин", ENV['GMAIL_SMTP_USER'], ENV['GMAIL_SMTP_PASSWORD'], 'admin')
SeedTasks.create_user("посетитель", "znatok@example.com", 'znatok','znatok')
=end