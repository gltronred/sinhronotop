# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
class RackRailsCookieHeaderHack
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if headers['Set-Cookie'] && headers['Set-Cookie'].respond_to?(:collect!)
      headers['Set-Cookie'].collect! { |h| h.strip }
    end
    [status, headers, body]
  end
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  config.action_controller.session = {
    :key => '_chgk_session',
    :secret      => '4uiz23i45hjkfsjkfjsfkjosdhfjdshfjsdgfwt7izeuebydffdgqwqezwq7364732647326473sdjflisurwezwfe'
  }

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  #config.gem "authlogic"
  #config.gem "declarative_authorization", :source => "http://gemcutter.org"
  
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  
  
  config.after_initialize do
    ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, RackRailsCookieHeaderHack)
  end
  
  config.active_record.observers = :user_observer
  
  
end
=begin
class TrueClass
  def to_s
    "да"
  end
end

class FalseClass
  def to_s
    "нет"
  end
end
=end
module ActionView::Helpers::DateHelper
  alias_method :date_select_regular, :date_select

  def date_select(object_name, method, options = {}, html_options = {})
    options[:order] = [:day, :month, :year]
    options[:use_month_numbers] = true
    date_select_regular(object_name, method, options, html_options)
  end
end

class ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    :name => "Название",
    :answer => "Ответ",
    :moderator_name => "Имя и фамилия ведущего",
    :moderator_email => "Email ведущего",
    :num_tours => "Количество туров",
    :num_questions => "Количество вопросов в туре",
    :question_index => "Номер вопроса",
    :goal => "Цель",
    :argument => "Аргументация",
    :email => "Email",
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || attr
  end
end