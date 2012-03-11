class ResultsController < ApplicationController

  before_filter :load_result_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index, :show, :simple_results, :update_tour, :show_local_teams, :add_local_teams]
  before_filter :check_do_changes
  
  @@calculator = Calculator.new()

  def index
    if @event
      @result = Result.new
      @results = @parent.results.sort_by{|r| r.local_index }
      @results.each {|result| result.calculate_and_save }
      @team = Team.new
      load_teams
      load_cities
    else
      tag = params[:tag]
      tag_id = tag ? Tag.find_by_short_name(tag) : nil
      if tag_id
        results_unsorted = Result.find(:all, :include => [{:team => :city}, :event, :tag], :conditions => ["events.game_id = ? and tag_id = ?", @parent.id, tag_id])
      else
        results_unsorted = Result.find(:all, :include => [{:team => :city}, :event], :conditions => ["events.game_id = ?", @parent.id])
      end
      @results = results_unsorted.sort_by{|r| -r.score }
      calc_performed = @@calculator.calculate_places(@results, tag_id)
      Result.save_multiple(@results) if calc_performed && !tag_id
    end
    @context_array = @parent.parents_top_down(:with_me) << "результаты (#{@results.size})"
    respond_to do |format|
      format.html # index.html.erb
      format.csv # index.html.erb
    end
  end

  def update_tour
    event = Event.find(params[:event_id])
    tour = params[:tour].to_i
    items = params[:items].split(',').map(&:to_i)
    event.results.each do |result|
      result.items_for_tour(tour).each do |item|
        item.score = items.include?(item.id) ? 1 : 0
        item.save
      end
    end
    render :text => ''
  end

  def show
    @tour = params[:id].to_i
    @context_array = @parent.parents_top_down(:with_me) << "результаты" << "тур #{@tour}"
    @results = @parent.results.sort_by{|r| -r.score_for_tour(@tour) }

    @results.each {|result| result.calculate_and_save }
  end

  def create
    @result = Result.new(params[:result])
    @result.score = 0
    @result.cap_name = params[:cap_name] unless params[:cap_name].blank?
    @result.local_index = params[:local_index]
    @result.tag_id = params[:tag_id]

    respond_to do |format|
      if @result.save
        @result.create_resultitems
        @result.event.shift_local_indexes(@result, true)
        format.html { redirect_to(event_results_path(@event), :notice => 'Команда добавлена') }
      else
        format.html { redirect_to(event_results_path(@event), :notice => @result.e_to_s) }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result.destroy
    respond_to do |format|
      @result.event.shift_local_indexes(@result, false)
      format.html { redirect_to(event_results_path(@event)) }
    end
  end

  def edit
    @context_array = @event.parents_top_down(:with_me) << "изменить данные команды '#{@team.name}'"
    @team.from_rating? ? load_teams : load_cities
  end

  def update
    respond_to do |format|
      @team = Team.find(params[:team_id])
      ok = @team.from_rating? ? true : update_team(@team, params)
      format.html {
        if ok && @result.update_attributes(params[:result])
          redirect_to(event_results_path(@event), :notice => 'Данные команды обновлены')
        else
          redirect_to(edit_result_path(@result), :notice => "#{@team.e_to_s} #{@result.e_to_s}")
        end
      }
    end
  end

  def simple_results
    @results = @parent.results.sort_by{|r| -r.score }
    calc_performed = @@calculator.calculate_places(@results)
    Result.save_multiple(@results) if calc_performed
    @context_array = @parent.parents_top_down(:with_me) << "результаты (#{@results.size})"
    send_data render('simple_results.html', :layout => false),
    :filename => 'simple_results.html',
    :disposition => 'attachment',
    :type => "text/html; charset=utf-8; header=present",
    :encoding => 'utf-8'
  end
  
  def add_local_teams
    size = @event.results.size
    cap = @event.game.tournament.validate_cap_name?
    params[:event][:team_ids].each { |team_id|
      result = Result.new(:event => @event, :team => Team.find(team_id))
      result.cap_name = params[:event][:cap_names][team_id] if cap
      result.score = 0
      result.local_index = size+=1
      result.save
      result.create_resultitems
    }
    respond_to do |format|
      format.html { redirect_to(event_results_path(@event), :notice => 'Команды добавлены') }
    end
    
  end
  
  def show_local_teams
    @context_array = @event.parents_top_down(:with_me) << "добавить команды, приписанные к городу #{@event.city.name}"
    @teams = Team.find(:all, :conditions => ["city_id = ?", @event.city_id])
    @teams = @teams - @parent.results.map(&:team) if @parent.results
  end

  private
  
  def update_team(team, params) 
    team.name = params[:team_name]
    team.city_id = params[:city_id]
    team.save
  end

  def load_teams
    @teams_home   = Team.find(:all, :conditions => ["city_id = ?", @event.city_id], :joins => :city, :order => "name ASC")
    @teams_guests = Team.find(:all, :conditions => ["city_id != ?", @event.city_id], :joins => :city, :order => "name ASC")

    @teams_home << Team.new(:name => '--------------------') if !@teams_home.empty?
    @teams = @teams_home + @teams_guests
    @teams = @teams - @results.map(&:team) if @results
  end

  def load_result_with_parents
    @result = Result.find(params[:id])
    @event = @result.event
    @game = @event.game
    @team = @result.team
  end

  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_results? @event}
    else
      check_permissions{can_see_results? @game}
    end
  end

end
