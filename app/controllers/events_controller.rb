class EventsController < ApplicationController
  
  # GET /events
  # GET /events.xml
  def index
    @game = GamesController.find(params[:game_id])
    check_permissions { is_org? @game.tournament }
    @events = @game.events
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = EventsController.find(params[:id])
    check_permissions { is_resp? @event }
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new    
    @event = Event.new
    @event.game = @game = GamesController.find(params[:game_id])
    check_permissions { is_registrated? }
    check_time_constrains(@event.game){ @game.registrable }
    load_cities(@game.tournament_id)
    #load_users
  end

  # GET /events/1/edit
  def edit
    @event = EventsController.find(params[:id])
    check_permissions { is_resp? @event }
    load_cities(@event.game.tournament_id)
    #load_users
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    check_permissions { is_registrated? }
    respond_to do |format|
      if @event.save
        Emailer.deliver_notify_event(@event)
        format.html { redirect_to(@event, :notice => 'Регистрация прошла успешно, ждите подтверждения по email') }
      else
        format.html {
          @game = Game.find(@event.game_id)
          load_cities(@game.tournament_id)
          #load_users
          render :action => "new"
        }
      end
    end
  end


  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = EventsController.find(params[:id])
    check_permissions { is_resp? @event }
    respond_to do |format|
      if @event.update_attributes(params[:event])
        Emailer.deliver_notify_event(@event)
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
    @event = EventsController.find(params[:id])
    check_permissions { is_org? @event.game.tournament }
    @event.destroy
    respond_to do |format|
      format.html { redirect_to(game_events_url(@event.game), :noice => 'Регистрация удалена') }
    end
  end

  protected
  def load_users
    @users = User.all(:order => :name).select{|u| 'znatok' != u.status}
  end

  def load_cities(tournament_id)
    @cities = City.find(:all, :joins => :tournaments, :order => :name, :conditions => ["cities_tournaments.tournament_id = ?", tournament_id])
  end

  def self.find(id, options={})
    event = Event.find(id, options)
    if (!event)
      flash[:notice] = "Игра с id #{id} не найдена"
      redirect_to home_path
    end
    event
  end

end
