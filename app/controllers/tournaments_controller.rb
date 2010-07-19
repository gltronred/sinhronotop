class TournamentsController < ApplicationController
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
    @tournament = Tournament.find(params[:id], :joins => :cities)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @tournament = Tournament.new
    @cities = City.all
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
    @cities = City.all    
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(@tournament, :notice => 'Турнир создан') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @tournament = Tournament.find(params[:id])

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
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to(tournaments_url, :notice => 'Турнир удален') }
    end
  end
end
