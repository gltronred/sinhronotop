# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

desc "Drops, recreates and refills the database."
namespace :db do
  task :redb => ['db:drop', 'db:create', 'db:migrate', 'db:fixtures:load']
end

namespace :tmp do
  desc 'clear webrat files'
  task :clear => 'tmp:webrat:clear'

  namespace :webrat do
    desc "Clears webrat files in tmp/"
    task :clear do
      FileUtils.rm(Dir['tmp/webrat*'])
      FileUtils.rm(Dir['tmp/*.png'])
      FileUtils.rm(Dir['tmp/*.jpg'])
      FileUtils.rm(Dir['tmp/*.generating'])
      FileUtils.rm(Dir['tmp/*.xml'])
      FileUtils.rm(Dir['tmp/*.wgz'])
      FileUtils.rm(Dir['tmp/*-0'])
      FileUtils.rm_rf(Dir['tmp/*'])
    end
  end
end