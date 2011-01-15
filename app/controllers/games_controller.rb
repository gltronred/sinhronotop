class GamesController < ApplicationController
  include PermissionHelper

  #before_filter :authenticate, :except => [:index, :show]

  # GET /games
  # GET /games.xml
  def index
    @tournament = TournamentsController.find(params[:tournament_id])
    @games = @tournament.games
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @tournament = TournamentsController.find(params[:tournament_id])
    org?(@tournament, true)
    @game = Game.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /games/1/edit
  def edit
    @game = GamesController.find(params[:id])
    @tournament = @game.tournament
    org?(@tournament, true)
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])
    org?(@game.tournament, true)
    respond_to do |format|
      if @game.save
        format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Этап создан.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = GamesController.find(params[:id])
    org?(@game.tournament, true)
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Параметры этапа изменены.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = GamesController.find(params[:id])
    org?(@game.tournament, true)
    @game.destroy
    respond_to do |format|
      format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Этап удален.') }
    end
  end
  
  protected
  
  def self.find(id, options={})
    game = Game.find(id, options)
    if (!game)
      flash[:notice] = "Этап с id #{id} не найдена"
      redirect_to home_path
    end
    game
  end
  
end
