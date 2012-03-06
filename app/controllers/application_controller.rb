# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ApplicationHelper, AuthenticatedSystem, PermissionHelper

  before_filter do |controller|
    controller.authenticate unless controller.is_a?(SessionsController) || controller.is_a?(UsersController)
  end
  after_filter { |c| if "text/csv" == c.response.headers['Content-Type'] then c.response.body = c.to_cyrillic(c.request.query_parameters[:format], c.response.body); puts "E" end  }

  helper_method :all
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def to_cyrillic(format, str)
    format ||= 'utf-8'
    conv = @@converters[format]
    str && conv ? conv.iconv(str) : ""
  end

  def load_cities
    @cities = City.all(:order => :name)
  end

  protected

  private
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
end
