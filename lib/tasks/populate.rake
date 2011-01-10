namespace :db do
  task :populate => :environment do
    require 'populator'
    require 'faker'
    [User].each(&:delete_all)
    admin = User.create(:email => 'ckgkresults@gmail.com', :password => '34erdfcv', :role => 'admin')
    org = User.create(:email => 'org@gmail.com', :password => 'org', :role => 'org')
    resp = User.create(:email => 'resp@gmail.com', :password => 'resp', :role => 'resp')
    
  end
end