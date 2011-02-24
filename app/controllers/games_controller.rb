class GamesController < ApplicationController

  before_filter :find, :only => [:update, :edit, :destroy, :show ]
  before_filter :find_tournament, :only => [:new, :create ]
  before_filter :check_do_change, :only => [:edit, :update, :destroy, :new, :create]

  def show
    respond_to do |format|
      @context_array = @game.parents_top_down(:with_me)
      format.html # show.html.erb
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new
    @context_array = @tournament.parents_top_down(:with_me) << "новый этап"
  end

  # GET /games/1/edit
  def edit
    @context_array = @game.parents_top_down(:with_me) << "изменить детали"
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])
    respond_to do |format|
      if @game.save
        format.html { redirect_to(tournament_url(@tournament), :notice => 'Этап создан.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    respond_to do |format|
      [:begin, :end, :game_begin, :game_end, :submit_disp_until, :submit_appeal_until, :submit_results_until].each{|prefix|
        ["(1i)", "(2i)", "(3i)"].each{|suffix|
          params[:game]["#{prefix}#{suffix}"] ||= ""
        }
      }
      if @game.update_attributes(params[:game])
        format.html { redirect_to(tournament_url(@game.tournament), :notice => 'Параметры этапа изменены.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to(tournament_url(@game.tournament), :notice => 'Этап удален.') }
    end
  end

  protected

  def find
    @game = Game.find params[:id] if params[:id]
    if @game
      @tournament = @game.tournament
    else
      flash[:notice] = "Этап с id #{id} не найден"
      redirect_to home_path
    end
  end

  def find_tournament
    if params[:tournament_id]
      @tournament = Tournament.find params[:tournament_id]
    elsif params[:game] && params[:game][:tournament_id]
      @tournament = Tournament.find params[:game][:tournament_id]
    end
    unless @tournament
      flash[:notice] = "Этап не найден"
      redirect_to home_path
    end
  end

  def check_do_change
    check_permissions { is_org? @tournament }
  end

end
