class ResultsController < ApplicationController

  before_filter :load_result_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index]
  before_filter :check_do_changes
  before_filter :check_edit_team, :only => [:edit, :update]

  # GET /results
  # GET /results.xml
  def index
    if @event
      @result = Result.new
      @results = @parent.results.sort{|x,y| x.team.name <=> y.team.name}
      @results.each {|result| result.calculate_and_save }
      @team = Team.new
      @teams = Team.find(:all, :joins => :city, :order => "name ASC") - @results.map(&:team)
      load_cities
    elsif
      @results = @parent.results.sort{|x,y| y.score <=> x.score}
      calculate_places(@results)
    end
    @context_array = @parent.parents_top_down(:with_me) << "результаты"
    respond_to do |format|
      format.html # index.html.erb
      format.csv # index.html.erb
    end
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])
    @result.score = 0
    respond_to do |format|
      if @result.save
        @result.create_resultitems
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
      format.html { redirect_to(event_results_path(@event)) }
    end
  end
  
  def edit
    load_cities
  end

  def update
    respond_to do |format|
      @team = Team.find(params[:team_id])
      @team.name = params[:team_name]
      @team.city_id = params[:city_id]      
      if @team.save && @result.update_attributes(params[:result])
        format.html { redirect_to(event_results_path(@event), :notice => 'Данные команды обновлены') }
      else
        format.html { 
          load_cities
          render :action => "edit" 
          }
      end
    end
  end
  
  private

  def check_edit_team
    check_permissions { @team.editable? }
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
      ordered_results.group_by(&:score).each do |score, group|
        group.each{|r|r.place_begin = teams_before+1; r.place_end = teams_before+group.size; r.save}
        teams_before += group.size
      end
    end
  end

end
