class DisputedsController < ApplicationController

  before_filter :load_parents
  
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
    event = Event.find_by_id(@disputed.event_id);
    check_time_constrains(event) {event.is_modifiable? 'disp'}
  end

  # POST /disputeds
  # POST /disputeds.xml
  def create
    @disputed = Disputed.new(params[:disputed])
    event = Event.find_by_id(@disputed.event_id);
    check_time_constrains(event) {event.is_modifiable? 'disp'}

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
    event = Event.find_by_id(@disputed.event_id);
    check_time_constrains(event) {event.is_modifiable? 'disp'}

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
    event = Event.find_by_id(@disputed.event_id);
    check_time_constrains(event) {event.is_modifiable? 'disp'}
    
    @disputed.destroy
    respond_to do |format|
      format.html { redirect_to(event_disputeds_url(event), :notice => 'Спорный удален.') }
    end
  end
end