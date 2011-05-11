class ResultsController < ApplicationController

  before_filter :load_result_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index, :show]
  before_filter :check_do_changes

  # GET /results
  # GET /results.xml
  def index
    if @event
      @result = Result.new
      @results = @parent.results.sort_by{|r| r.local_index }
      @results.each {|result| result.calculate_and_save }
      @team = Team.new
      load_teams
      load_cities
    elsif
      @results = @parent.results.sort_by{|r| -r.score }
      calculate_places(@results)
    end
    @context_array = @parent.parents_top_down(:with_me) << "результаты (#{@results.size})"
    respond_to do |format|
      format.html # index.html.erb
      format.csv # index.html.erb
    end
  end
  
  def show
    @tour = params[:id].to_i
    @context_array = @parent.parents_top_down(:with_me) << "результаты" << "тур #{@tour}"
    @results = @parent.results.sort_by{|r| -r.score }
    @results.each {|result| result.calculate_and_save }
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])
    @result.score = 0
    @result.cap_name = params[:cap_name]
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

  private

  def load_teams
    #@teams = Team.find(:all, :joins => :city, :order => "name ASC")
    #puts "!!!!!!!!!!!!!!!!"+YAML::dump(@_event)
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

  def calculate_places(ordered_results)
    need_calc = ordered_results.detect{|r|!r.place_begin || !r.place_end}
    if need_calc
      teams_before = 0
      ordered_results.group_by{|r|-r.score}.each do |score, group|
        group.each{|r|r.place_begin = teams_before+1; r.place_end = teams_before+group.size; r.save}
        teams_before += group.size
      end
    end
  end

end
