class GamesController < ApplicationController
  include PermissionHelper

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
    do_with_protection { is_org?(@tournament) }
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game = GamesController.find(params[:id])
    @tournament = @game.tournament
    do_with_protection { is_org?(@tournament) }
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])
    @tournament = @game.tournament
    do_with_protection { is_org?(@tournament) }
    respond_to do |format|
      if @game.save
        format.html { redirect_to(tournament_games_url(@tournament), :notice => 'Этап создан.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = GamesController.find(params[:id])
    do_with_protection { is_org?(@game.tournament) }
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
    do_with_protection { is_org?(@game.tournament) }
    @game.destroy
    respond_to do |format|
      format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Этап удален.') }
    end
  end
  
  protected
  
  def self.find(id, options={})
    game = Game.find(id, options)
    if (!game)
      flash[:notice] = "Этап с id #{id} не найден"
      redirect_to home_path
    end
    game
  end
  
end
