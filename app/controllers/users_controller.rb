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
      self.current_user = @user # !! now logged in
      redirect_back_or_default(home_path)
      flash[:notice] = "Спасибо за регистрацию! Вы получите email с подтверждением"
    else
      @admin = User.find_by_status('admin')
      flash[:error]  = "Регистрация не удалась. Попробуйте еще раз"
      render :action => 'new'
    end
  end

  def forgot
    if request.post?
      email = params[:user][:email]
      user = User.find_by_email(email)
      if user
        user.create_reset_code
        flash[:notice] = "Код для восстановления послан на адрес #{email}"
      else
        flash[:notice] = "Пользователь с адресом #{email} нам неизветен"
      end
      redirect_back_or_default(home_path)
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Пароль для #{@user.email} изменен"
        redirect_back_or_default(home_path)
      else
        render :action => :reset
      end
    end
  end
end
