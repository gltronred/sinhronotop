class UsersController < ApplicationController

  def show
    @user = current_user
    @context_array = ["Информация о пользователе"]
  end

  def account
    if logged_in?
      @user = current_user
    else
      flash[:notice] = 'Вы пока не вошли в систему, попробуйте это сделать или зарегистрироваться'
      render :controller => 'session', :action => 'new'
    end
  end

  def edit_password
    @user = current_user
    @context_array = ["Пользователь #{current_user.name}", "Сменить пароль"]
  end

  # action to perform when the user wants to change their password
  def update_password
    return unless request.post?
    #if User.authenticate(current_user.login, params[:old_password])
    #      if (params[:password] == params[:password_confirmation])
    current_user.password_confirmation = params[:user][:password_confirmation]
    current_user.password = params[:user][:password]
    if current_user.save
      flash[:notice] = "Новый пароль действителен"
      redirect_to user_path(current_user)
    else
      @user = current_user
      flash[:notice] = "Пароль сменить не удалось"
      render :action => "edit_password"
    end
    #      else
    #        flash[:alert] = "New password mismatch"
    #        @old_password = params[:old_password]
    #      end
    #else
    #  flash[:notice] = "Старый пароль неверен"
    #  render :action => "edit_password"
    #end
  end

  # render new.rhtml
  def new
    @admin = User.find_by_status('admin')
    @user = User.new
    @context_array = ["Новый пользователь"]
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if @user && @user.save
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      #self.current_user = @user # !! now logged in
      #redirect_back_or_default(home_path)
      #@user.create_activation_code
      redirect_to home_path
      flash[:notice] = "Спасибо! Чтобы завершить регистрацию, проверьте почту и пойдите по ссылке в письме."
    else
      #@admin = User.find_by_status('admin')
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

  def activate
    @user = User.find_by_activation_code(params[:activation_code]) if params[:activation_code]
    if @user
      self.current_user = @user
      @user.delete_activation_code
      flash[:notice] = "Спасибо, регистрация закончена"
      redirect_back_or_default(home_path)
    else
      redirect_to home_path
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
