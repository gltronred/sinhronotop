# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:notice] = "Добро пожаловать."
      redirect_back_or_default(home_path)
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render "home/index"
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "До свидания."
    redirect_back_or_default(home_path)
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Войти с '#{params[:email]}' и заданным паролем не удалось"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
