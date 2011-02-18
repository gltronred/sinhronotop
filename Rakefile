# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require "net/http"
require 'uri'
require 'tasks/rails'

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
