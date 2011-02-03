class UsersController < ApplicationController
  
  # render new.rhtml
  def new
    @admin = User.find_by_status('admin')
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      Emailer.deliver_user_registred @user
      self.current_user = @user # !! now logged in
      redirect_back_or_default(home_path)
      flash[:notice] = "Спасибо за регистрацию! Вы получите email с подтверждением"
    else
      @admin = User.find_by_status('admin')
      flash[:error]  = "Регистрация не удалась. Попробуйте еще раз"
      render :action => 'new'
    end
  end
end
