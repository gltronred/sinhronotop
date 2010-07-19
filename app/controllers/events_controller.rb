class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @game = Game.find(params[:game_id])
    @events = @game.events

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @game = Game.find(params[:game_id])
    @cities = City.find(:all, :joins => :tournaments, :order => "name DESC", :conditions => ["cities_tournaments.tournament_id = ?", @game.tournament_id])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @game = @event.game
    @cities = City.find(:all, :joins => :tournaments, :order => "name DESC", :conditions => ["cities_tournaments.tournament_id = ?", @game.tournament_id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        Emailer.deliver_notify_event(@event)
        format.html { redirect_to(@event, :notice => 'Регистрация прошла успешно, ждите подтверждения по email') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        Emailer.deliver_notify_event(@event)
        format.html { redirect_to(@event, :notice => 'Параметры изменены, ждите подтверждения по email') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(game_events_url(@event.game), :noice => 'Регистрация удалена') }
    end
  end
end
