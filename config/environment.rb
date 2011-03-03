# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'iconv'
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
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  
  
  config.after_initialize do
    ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, RackRailsCookieHeaderHack)
  end
  
  config.active_record.observers = :user_observer, :event_observer
end

class String
  def opt_brackets
    self.length > 0 ? "(#{self})" : self
  end
end

class Array
  def sort_by_nilable(attribute)
    self.sort{|a,b|( a.send(attribute) and b.send(attribute) ) ? a.send(attribute) <=> b.send(attribute) : ( a.send(attribute) ? 1 : -1 ) }
  end
end

class ActiveRecord::Base
  def parents_top_down(with_me=false)
    ret = self.get_parent ? self.get_parent.parents_top_down(true) : []
    ret<<self if with_me
    ret
  end
  
  def e_to_s
    self.errors.full_messages.join(', ')
  end
end

class TrueClass
  def loc
    "да"
  end
end

class FalseClass
  def loc
    "нет"
  end
end

class Date
  def loc
    self.strftime('%d.%m.%Y')
  end
end

module ActionView::Helpers::DateHelper
  alias_method :date_select_regular, :date_select

  def date_select(object_name, method, options = {}, html_options = {})
    options[:order] = [:day, :month, :year]
    options[:use_month_numbers] = true
    date_select_regular(object_name, method, options, html_options)
  end
end

module ActionView::Helpers::FormOptionsHelper
   def options_for_select_with_include_blank(container, selected = nil, include_blank = false)
      options = options_for_select_without_include_blank(container, selected)
      if include_blank
         options = "<option value=\"\">#{include_blank if include_blank.kind_of?(String)}</option>\n" + options
      end
      options
   end
   alias_method_chain :options_for_select, :include_blank
 
   def options_from_collection_for_select_with_include_blank(collection, value_method, text_method, selected = nil, include_blank = false)
      options = options_from_collection_for_select_without_include_blank(collection, value_method, text_method, selected)
      if include_blank
         options = "<option value=\"\">#{include_blank if include_blank.kind_of?(String)}</option>\n" + options
      end
      options
   end
   alias_method_chain :options_from_collection_for_select, :include_blank
end

class ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    :name => "название",
    :answer => "ответ",
    :password => "пароль",
    :moderator_name => "имя и фамилия ведущего",
    :moderator_email => "email ведущего",
    :num_tours => "количество туров",
    :num_questions => "количество вопросов в туре",
    :question_index => "номер вопроса",
    :goal => "цель",
    :argument => "аргументация",
    :email => "email",
    :cap_name => "имя и фамилия капитана",
    :num_teams => "количество команд",
    :more_info => "дополнительна информация",
    :game_time => "время начала игры"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || attr
  end
end