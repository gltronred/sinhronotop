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
    unless City.find_by_name name
      City.create :name => name
    end
  end
end

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
SeedTasks.create_user("Михаил Перлин", ENV['GMAIL_SMTP_USER'], ENV['GMAIL_SMTP_PASSWORD'], 'admin')
SeedTasks.create_user("посетитель", "znatok@example.com", 'znatok','znatok')
