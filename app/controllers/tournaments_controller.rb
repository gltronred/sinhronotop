class TournamentsController < ApplicationController
  include PermissionHelper

  #before_filter :authenticate, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :only => [:new, :create, :destroy] do |controller| 
    controller.do_with_protection { controller.is_admin? }
  end

  # GET /tournaments
  # GET /tournaments.xml
  def index
    @tournaments = Tournament.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    @tournament = TournamentsController.find(params[:id])#, :joins => :cities)
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @tournament = Tournament.new
    load_cities
    load_users
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = TournamentsController.find(params[:id])
    do_with_protection { is_org?(@tournament) }
    
    load_users
    load_cities
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @tournament = Tournament.new(params[:tournament])
    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(@tournament, :notice => 'Турнир создан') }
      else
        format.html { 
          load_cities
          render :action => "new"
        }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @tournament = TournamentsController.find(params[:id])
    do_with_protection { is_org?(@tournament) }
    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to(@tournament, :notice => 'Данные турнира изменены') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @tournament = TournamentsController.find(params[:id])
    do_with_protection { is_org?(@tournament) }
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to(tournaments_url, :notice => 'Турнир удален') }
    end
  end

  protected
  
  def load_cities
    @cities = City.all(:order => :name)
  end

  def load_users
    @users = User.all(:order => :name).select{|u| 'znatok' != u.status}
  end
  
  def self.find(id, options={})
    tournament = Tournament.find(id, options)
    if (!tournament)
      flash[:notice] = "Турнир с id #{id} не найден"
      redirect_to home_path
    end
    tournament
  end

end
