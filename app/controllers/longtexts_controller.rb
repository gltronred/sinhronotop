class LongtextsController < ApplicationController

  before_filter :load_longtext_with_parents, :only => [:update, :edit, :show, :destroy, :show]
  before_filter :load_parents, :only => [:new, :create]
  before_filter :check_do_changes, :except => :show

  def show
    @context_array = @parent.parents_top_down(:with_me) << "#{@longtext.title}"
  end

  def edit
    @context_array = @parent.parents_top_down(:with_me) << "изменить '#{@longtext.title}'"
  end

  def new
    @longtext = Longtext.new(:new_page => true)
    @context_array = @parent.parents_top_down(:with_me) << "новый текст"
  end

  def create
    @longtext = Longtext.new(params[:longtext])
    respond_to do |format|
      format.html {
        if @longtext.save
          redirect_to(polymorphic_url(@parent), :notice => 'Текст сохранен.')
        else
          redirect_to(new_longtext_url, :notice => @longtext.e_to_s)
        end
      }
    end
  end

  def update
    respond_to do |format|
      if @longtext.update_attributes(params[:longtext])
        format.html { redirect_to(polymorphic_url(@parent), :notice => 'Текст изменен.') }
      else
        format.html { redirect_to(edit_longtext_url(@longtext), :notice => @longtext.e_to_s) }
      end
    end
  end

  def destroy
    @longtext.destroy
    respond_to do |format|
      format.html { redirect_to(polymorphic_url(@parent), :notice => 'Текст удален.') }
    end
  end

  private

  def load_longtext_with_parents
    @longtext = Longtext.find(params[:id])
    if @longtext.tournament
      @parent = @tournament = @longtext.tournament
    elsif @longtext.game
      @parent = @longtext.game
      @tournament = @parent.tournament
    end
  end

  def load_parents
    game_id = params[:game_id]
    game_id ||= params[:longtext][:game_id] if !game_id && params[:longtext]
    if game_id
      @parent = @game = Game.find(game_id)
      @tournament = @game.tournament
    else
      tournament_id = params[:tournament_id]
      tournament_id = params[:longtext][:tournament_id] if !tournament_id && params[:longtext]
      @parent = @tournament = Tournament.find(tournament_id) if tournament_id
    end
  end

  def check_do_changes
    check_permissions{is_org? @tournament}
  end
end
