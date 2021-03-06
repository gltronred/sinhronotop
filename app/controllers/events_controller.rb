class EventsController < ApplicationController

  @@ENCODING = "WINDOWS-1251"

  before_filter :find, :only => [:edit, :update, :destroy, :show, :change_status, :payment, :update_payment]
  before_filter :find_game, :only => [:index, :new, :create]

  before_filter :do_org_actions, :only => [:index, :change_status]
  before_filter :check_change_event, :only => [:edit, :update, :destroy, :update_payment]
  before_filter :check_create_event, :only => [:new, :create]
  before_filter :check_do_changes, :only => [:casts]

  def change_status
    if @event.update_status EventStatus.find_by_id(params[:new_status_id])
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @events = @game.events.sort{|x,y|x.city.name <=> y.city.name}
    @context_array = @game.parents_top_down(:with_me) << "все заявки (#{@events.size})"
    respond_to do |format|
      format.html
      format.csv
      format.xls
    end
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
    load_users
    @context_array = @game.parents_top_down(:with_me) << "регистрация"
  end

  # GET /events/1/edit
  def edit
    load_cities(@event.game.tournament_id)
    load_users
    @context_array = @event.parents_top_down(:with_me) << "изменить данные регистрации"
  end

  # POST /events
  # POST /events.xml
  def create
    params[:event].merge!(:ips => request.remote_ip)
    @event = Event.new(params[:event])

    if (@event.validate_event_date)
      respond_to do |format|
        if @event.save
          format.html { redirect_to(@event, :notice => @event.last_change) }
        else
          format.html {
            @game = Game.find(@event.game_id)
            load_users
            load_cities(@game.tournament_id)
            render :action => "new"
          }
        end
      end
    else
      @game = Game.find(@event.game_id)
      load_users
      load_cities(@game.tournament_id)
      flash[:notice] = 'Неверно указана дата игры.'
      render :action => "new"
    end
  end


  # PUT /events/1
  # PUT /events/1.xml
  def update
    respond_to do |format|
      @event.update_moderator_id params[:event][:moderation_id]
      params[:event].merge!(:ips => "#{@event.ips}#{',' if @event.ips} #{request.remote_ip}")
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => @event.last_change) }
      else
        format.html {
          load_cities(@event.game.tournament_id)
          load_users
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
      format.html { redirect_to(game_events_url(@event.game), :noice => 'Заявка удалена') }
    end
  end

  def casts
    load_parents
    load_cities(@event.game.tournament_id)
    load_users
#    check_change_event
    @context_array = @event.parents_top_down(:with_me) << 'Составы'
    @results = @event.results.sort_by{|r| r.local_index }
  end
  
  def payment
    load_parents
    @context_array = @event.parents_top_down(:with_me) << 'Платеж'
  end
  
  def update_payment
    load_parents
    @event.payment_done = params[:payment_done]
    @event.payment_amount = params[:payment_amount]
    @event.payment_way = params[:payment_way]
    if @event.save
      redirect_to event_path(@event)
    else
      render :action => "payment"
    end
  end

  def export_casts
    load_parents
    load_users
    @results = @event.results
    data = to_cyrillic(@@ENCODING, render('export_casts.csv', :layout => false))
    send_data data,
    :filename => "event_#{@event.id}_sostavy.csv",
    :disposition => 'attachment',
    :type => "text/csv; charset=#{@@ENCODING} ; header=present",
    :encoding => @@ENCODING
  end

  protected

  def load_cities(tournament_id)
    if @game.tournament.every_city
      @cities = City.all(:order => :name)
    else
      @cities = City.find(:all, :joins => :tournaments, :order => :name, :conditions => ["cities_tournaments.tournament_id = ?", tournament_id]).uniq
    end
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

  def check_do_changes
    load_parents
    if @event
      check_time_constrains(@event) {can_submit_results? @event}
    else
      check_permissions{can_see_results? @game}
    end
  end

  def check_create_event
    check_permissions { is_registrated? } && check_time_constrains(@game){ can_register? @game }
  end


end
