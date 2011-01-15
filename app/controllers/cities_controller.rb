class CitiesController < ApplicationController
  include PermissionHelper

  #before_filter :authenticate
  before_filter :check_admin
  
  # GET /cities
  # GET /cities.xml
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = CitiesController.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /cities/1/edit
  def edit
    @city = CitiesController.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'Город создан.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = CitiesController.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'Данные сохранены.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = CitiesController.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
    end
  end
  
  protected

  def self.find(id, options={})
    city = City.find(id, options)
    if (!city)
      flash[:notice] = "Город с id #{id} не найден"
      redirect_to home_path
    end
    city
  end
  
end
