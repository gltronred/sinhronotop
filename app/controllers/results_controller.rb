class ResultsController < EventSubresourcesController
  include PermissionHelper

  before_filter :load_parents

  # GET /results
  # GET /results.xml
  def index
    if @event
      @result = Result.new
      @results = @parent.results
      @results.each {|result| result.calculate_and_save }
      @team = Team.new
      @teams = Team.find(:all, :order => "name ASC")
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
    modify_event_results?(Event.find_by_id(@result.event_id), 'results', true)

    respond_to do |format|
      if @result.save
        create_resultitems(@result)
        format.html { redirect_to(event_results_path(@result.event), :notice => 'Result was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  private
  def create_resultitems(result)
    for i in 1..result.event.game.num_tours*result.event.game.num_questions
      params =
      { :result_id      => result.id,
        :question_index => i,
      :score          => 0 }
      resultitem = Resultitem.new(params)
      resultitem.save
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    @result = Result.find(params[:id])
    modify_event_results?(@result.event, 'results', true)

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
    modify_event_results?(@result.event, 'results', true)

    @result.destroy
    respond_to do |format|
      format.html { redirect_to(event_results_path(@result.event)) }
    end
  end
end
