class EventsController < ApplicationController

  before_filter :find, :only => [:edit, :update, :destroy, :show, :change_status]
  before_filter :find_game, :only => [:index, :new, :create]

  before_filter :do_org_actions, :only => [:index, :change_status]
  before_filter :check_change_event, :only => [:edit, :update, :destroy, :show]
  before_filter :check_create_event, :only => [:new, :create]

  def change_status
    @event.event_status = EventStatus.find_by_id(params[:new_status_id])
    if @event.save
      Emailer.deliver_notify_event(@event, "статус заявки изменен")
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @events = @game.events
    @context_array = @game.parents_top_down(:with_me) << "все регистрации"
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    respond_to do |format|
      @context_array = @event.parents_top_down(:with_me)
      format.html # show.html.erb
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    load_cities(@game.tournament_id)
    @context_array = @game.parents_top_down(:with_me) << "зарегистрироваться"
  end

  # GET /events/1/edit
  def edit
    load_cities(@event.game.tournament_id)
    @context_array = @event.parents_top_down(:with_me) << "изменить регистрацию"
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.event_status = EventStatus.find_by_short_name("new")
    respond_to do |format|
      if @event.save
        Emailer.deliver_notify_event(@event, "заявка принята")
        format.html { redirect_to(@event, :notice => 'Регистрация прошла успешно, ждите подтверждения по email') }
      else
        format.html {
          @game = Game.find(@event.game_id)
          load_cities(@game.tournament_id)
          render :action => "new"
        }
      end
    end
  end


  # PUT /events/1
  # PUT /events/1.xml
  def update
    respond_to do |format|
      if @event.update_attributes(params[:event])
        Emailer.deliver_notify_event(@event, "данные заявки изменены")
        format.html { redirect_to(@event, :notice => 'Параметры изменены, ждите подтверждения по email') }
      else
        format.html {
          load_cities(@event.game.tournament_id)
          render :action => "edit"
        }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to(game_events_url(@event.game), :noice => 'Регистрация удалена') }
    end
  end

  protected

  def load_cities(tournament_id)
    conditions = @game.tournament.every_city ? nil : ["cities_tournaments.tournament_id = ?", tournament_id]
    @cities = City.find(:all, :joins => :tournaments, :order => :name, :conditions => conditions).uniq
  end

  def find
    @event = Event.find params[:id]
    if @event
      @game = @event.game
    else
      flash[:notice] = "Игра с id #{id} не найдена"
      redirect_to home_path
    end
  end

  def find_game
    if params[:game_id]
      @game = Game.find(params[:game_id])
    elsif params[:event] && params[:event][:game_id]
      @game = Game.find(params[:event][:game_id])
    end
    unless @game
      flash[:notice] = "Игра не найдена"
      redirect_to home_path
    end
  end

  def do_org_actions
    check_permissions { is_org? @game.tournament }
  end

  def check_change_event
    check_permissions { is_resp? @event } && check_time_constrains(@game){ can_register? @game }
  end

  def check_create_event
    check_permissions { is_registrated? } && check_time_constrains(@game){ can_register? @game }
  end
end
