class DisputedsController < ApplicationController

  before_filter :load_parents
  before_filter :check_do_changes, :only => [:index, :edit, :create, :update, :destroy]
  
  # GET /disputeds
  # GET /disputeds.xml
  def index
    @disputed = Disputed.new
    @disputeds = @parent.disputeds.sort {|x,y| x.question_index <=> y.question_index}
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /disputeds/1/edit
  def edit
    @disputed = Disputed.find(params[:id])
  end

  # POST /disputeds
  # POST /disputeds.xml
  def create
    @disputed = Disputed.new(params[:disputed])
    respond_to do |format|
      if @disputed.save
        format.html { redirect_to(event_disputeds_url(event), :notice => 'Спорный сохранен.') }
      else
        format.html { redirect_to(event_disputeds_url(event))}
      end
    end
  end

  # PUT /disputeds/1
  # PUT /disputeds/1.xml
  def update
    @disputed = Disputed.find(params[:id])
    respond_to do |format|
      if @disputed.update_attributes(params[:disputed])
        format.html { redirect_to(event_disputeds_url(event), :notice => 'Спорный изменен.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /disputeds/1
  # DELETE /disputeds/1.xml
  def destroy
    @disputed = Disputed.find(params[:id])
    @disputed.destroy
    respond_to do |format|
      format.html { redirect_to(event_disputeds_url(event), :notice => 'Спорный удален.') }
    end
  end
  
  private 
  
  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_disp? @event}
    else
      check_permissions{can_see_disp? @game}
    end
  end
end