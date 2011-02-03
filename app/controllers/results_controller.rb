class ResultsController < ApplicationController
  
  before_filter :load_parents
  before_filter :check_do_changes, :only => [:index, :edit, :create, :update, :destroy]

  # GET /results
  # GET /results.xml
  def index
    if @event
      @result = Result.new
      @results = @parent.results
      @results.each {|result| result.calculate_and_save }
      @team = Team.new
      @teams = Team.find(:all, :order => "name ASC")-@results.map(&:team)
    elsif
      @results = @parent.results.sort{|x,y| y.score <=> x.score}
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])
    @result.score = 0
    respond_to do |format|
      if @result.save!
        @result.create_resultitems
        format.html { redirect_to(event_results_path(event), :notice => 'Команда добавлена') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    @result = Result.find(params[:id])
    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to(@result, :notice => 'Result was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result = Result.find(params[:id])
    @result.destroy
    respond_to do |format|
      format.html { redirect_to(event_results_path(@result.event)) }
    end
  end
  
  private
  
  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_results? @event}
    else
      check_permissions{can_see_results? @game}
    end
  end
  
end
