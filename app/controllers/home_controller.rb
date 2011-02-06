class HomeController < ApplicationController

  def index
    @my_items = current_user.events + current_user.tournaments
    render :action => 'index'
  end

  def new_error
    render :action => 'new_error'
  end

  def create_error
    Emailer.deliver_error_notification(params[:name], params[:email], params[:text])
    redirect_to(home_path, :notice => 'Сообщение послано администратору, спасибо')
  end
end
