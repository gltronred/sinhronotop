class HomeController < ApplicationController
  include PermissionHelper

  def index
    render :action => 'index'
  end
  
end