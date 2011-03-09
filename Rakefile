# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require "net/http"
require 'uri'
require 'tasks/rails'

require "heroku_backup_task/tasks"
task :cron => :heroku_backup

namespace :db do
  desc "Drops, recreates and refills the database."
  task :redb => ['db:drop', 'db:create', 'db:migrate', 'db:fixtures:load']

  desc "add countries"
  task :add_countries => :environment do
    City.all.each do |city|
      unless city.country
        country = get_country(city.name)
        if country
          city.country = country
          city.save
        end
      end
    end
  end
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

def get_country(city_name)
  escaped = url_escape city_name
  uri = URI.parse("http://ru.wikipedia.org/wiki/#{escaped}")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  response.body.scan(/<span class=\"country-name\">(.*)<\/span><\/span>/).flatten.first
end

def url_escape(string)
  string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
    '%' + $1.unpack('H2' * $1.size).join('%').upcase
  end.tr(' ', '+')
end

def url_unescape(string)
  string.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
    [$1.delete('%')].pack('H*')
  end
end

#http://trevorturk.com/2010/04/14/automated-heroku-backups/
#http://groups.google.com/group/heroku/browse_thread/thread/39f34dbc4ab632d5
namespace :heroku do
  desc "PostgreSQL database backups from Heroku to Dropbox"
  task :backup => :environment do
    begin
      require 'dropbox'      
      puts "[#{Time.now}] heroku:backup started"
      name = "#{ENV['APP_NAME']}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.dump"
      db = ENV['DATABASE_URL'].match(/postgres:\/\/([^:]+):([^@]+)@([^\/]+)\/(.+)/)
      system "PGPASSWORD=#{db[2]} pg_dump -Fc --username=#{db[1]} --host=#{db[3]} #{db[4]} > tmp/#{name}"
      #s3 = RightAws::S3.new(ENV['s3_access_key_id'], ENV['s3_secret_access_key'])
      #bucket = s3.bucket("#{ENV['APP_NAME']}-heroku-backups", true, 'private')
      #bucket.put(name, open("tmp/#{name}"))
      d = DropBox.new(ENV["DROPBOX_USER"], ENV["DROPBOX_PWD"]) 
      d.create("tmp/#{name}", "/#{ENV["APP_NAME"]}/cron_backup/")      
      system "rm tmp/#{name}"
      puts "[#{Time.now}] heroku:backup complete"
    # rescue Exception => e
    #   require 'toadhopper'
    #   Toadhopper(ENV['hoptoad_key']).post!(e)
    end
  end
end

task :cron => :environment do
  Rake::Task['heroku:backup'].invoke
end