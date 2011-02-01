# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

module SeedTasks
  def self.create_user(name, email, password, status=nil)
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


City.delete_all
City.create :name => "Кёльн"
City.create :name => "Франкфурт"
City.create :name => "Берлин"
City.create :name => "Хемниц"
City.create :name => "Дортмунд"
City.create :name => "Кобленц"
City.create :name => "Нюрнберг"
City.create :name => "Штутгарт"
City.create :name => "Халле"
City.create :name => "Дюссельдорф"
City.create :name => "Мюнхен"
City.create :name => "Трир"
City.create :name => "Гамбург"

User.delete_all
SeedTasks.create_user("Михаил Перлин", "sinhronotop@googlemail.com", 'nora1901','admin')
SeedTasks.create_user("посетитель", "znatok@chgk.info", 'znatok','znatok')

