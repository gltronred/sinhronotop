namespace :db do
  task :populate => :environment do
    require 'populator'
    require 'faker'
  end
end