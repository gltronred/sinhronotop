# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ApplicationHelper, AuthenticatedSystem
  

  before_filter :mailer_set_url_options
  before_filter do |controller| 
    controller.authenticate unless controller.is_a?SessionsController
  end
  helper_method :eu_date, :is_admin?, :is_org?, :is_resp?, :is_registrated?
 
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
  
  private
  def mailer_set_url_options
     ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
