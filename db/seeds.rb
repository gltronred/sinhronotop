# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
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
  User.create(:name => "Михаил Перлин",
  :email => "sinhronotop@googlemail.com",
  :password => 'nora1901',
  :password_confirmation => 'nora1901',
  :status => 'admin')
  User.create(:name => "посетитель",
  :email => "znatok@chgk.info",
  :password => "znatok",
  :password_confirmation => 'znatok',
  :status => "znatok")