class DisputedsController < ApplicationController

  before_filter :load_disp_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index]
  before_filter :check_do_changes
  
  # GET /disputeds
  # GET /disputeds.xml
  def index
    @disputed = Disputed.new
    @disputeds = @parent.disputeds.sort {|x,y| x.question_index <=> y.question_index}
    respond_to do |format|
      @context_array = @parent.parents_top_down(:with_me) << "спорные ответы"
      format.html # index.html.erb
    end
  end

  # GET /disputeds/1/edit
  def edit
    @context_array = @disputed.parents_top_down << "изменить спорный"
  end

  # POST /disputeds
  # POST /disputeds.xml
  def create
    @disputed = Disputed.new(params[:disputed])
    respond_to do |format|
      if @disputed.save
        format.html { redirect_to(event_disputeds_url(@event), :notice => 'Спорный сохранен.') }
      else
        format.html { redirect_to(event_disputeds_url(@event))}
      end
    end
  end

  # PUT /disputeds/1
  # PUT /disputeds/1.xml
  def update
    respond_to do |format|
      if @disputed.update_attributes(params[:disputed])
        format.html { redirect_to(event_disputeds_url(@event), :notice => 'Спорный изменен.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /disputeds/1
  # DELETE /disputeds/1.xml
  def destroy
    @disputed.destroy
    respond_to do |format|
      format.html { redirect_to(event_disputeds_url(@event), :notice => 'Спорный удален.') }
    end
  end
  
  private

  def load_disp_with_parents
    @disputed = Disputed.find(params[:id])
    @event = @disputed.event
    @game = @event.game
  end
  
  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_disp? @event}
    else
      check_permissions{can_see_disp? @game}
    end
  end
end