class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @tournament = Tournament.find(params[:tournament_id])
    @games = @tournament.games

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
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
    @game = Game.new
    @tournament = Tournament.find(params[:tournament_id])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @tournament = @game.tournament
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Игра создана.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Параметры игры изменены.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(tournament_games_url(@game.tournament), :notice => 'Игра удалена.') }
    end
  end
end
