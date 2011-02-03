class HomeController < ApplicationController

  def index
    @my_items = current_user.events + current_user.tournaments
    render :action => 'index'
  end
  
end