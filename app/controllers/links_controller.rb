class LinksController < ApplicationController

  before_filter :load_link_with_parents, :only => [:update, :edit, :show, :destroy, :show]
  before_filter :load_parents, :only => [:new, :create]
  before_filter :check_do_changes, :except => :show

  def show
    @context_array = @parent.parents_top_down(:with_me) << "#{@link.text.html_safe}"
  end

  def edit
    @context_array = @parent.parents_top_down(:with_me) << "изменить '#{@link.text.html_safe}'"
  end

  def new
    @link = Link.new()
    @context_array = @parent.parents_top_down(:with_me) << "новая ссылка"
  end

  def create
    @link = Link.new(params[:link])
    respond_to do |format|
      format.html {
        if @link.save
          redirect_to(polymorphic_url(@parent), :notice => 'Ссылка сохранена.')
        else
          redirect_to(new_link_url, :notice => @link.e_to_s)
        end
      }
    end
  end

  def update
    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to(polymorphic_url(@parent), :notice => 'Ссылка изменена.') }
      else
        format.html { redirect_to(edit_link_url(@link), :notice => @link.e_to_s) }
      end
    end
  end

  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to(polymorphic_url(@parent), :notice => 'Ссылка удалена.') }
    end
  end

  private

  def load_link_with_parents
    @link = Link.find(params[:id])
    if @link.tournament
      @parent = @tournament = @link.tournament
    elsif @link.game
      @parent = @link.game
      @tournament = @parent.tournament
    end
  end

  def load_parents
    game_id = params[:game_id]
    game_id ||= params[:link][:game_id] if !game_id && params[:link]
    if game_id
      @parent = @game = Game.find(game_id)
      @tournament = @game.tournament
    else
      tournament_id = params[:tournament_id]
      tournament_id = params[:link][:tournament_id] if !tournament_id && params[:link]
      @parent = @tournament = Tournament.find(tournament_id) if tournament_id
    end
  end

  def check_do_changes
    check_permissions{is_org? @tournament}
  end
end
