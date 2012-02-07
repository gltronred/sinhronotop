class ResultsController < ApplicationController

  before_filter :load_result_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index, :show, :simple_results, :update_tour]
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
    elsif
      @results = Result.find(:all, :include => [{:team => :city}, :event], :conditions => ["events.game_id = ?", @parent.id]).sort_by{|r| -r.score }
      #@results = @parent.results.sort_by{|r| -r.score }
      calc_performed = @@calculator.calculate_places(@results)
      Result.save_multiple(@results) if calc_performed
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
      unless @team.from_rating?
        @team.name = params[:team_name]
        @team.city_id = params[:city_id]
      end
      format.html {
        if @team.save && @result.update_attributes(params[:result])
          redirect_to(event_results_path(@event), :notice => 'Данные команды обновлены')
        else
          #@team.from_rating? ? load_teams : load_cities
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
    :type => "text/html; charset=utf-8",
    :encoding => 'utf-8'
  end

  private

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
