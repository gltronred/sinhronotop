require 'event_subresources_controller'

class DisputedsController < EventsSubresourcesController
  before_filter :load_parents
  # GET /disputeds
  # GET /disputeds.xml
  def index
    @disputed = Disputed.new
    @disputeds = @parent.disputeds
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
    validate_update_by_date(@disputed)

    respond_to do |format|
      if @disputed.save
        format.html { redirect_to(event_disputeds_url(@disputed.event), :notice => 'Спорный сохранен.') }
      else
        format.html { redirect_to(event_disputeds_url(@disputed.event))}
      end
    end
  end

  # PUT /disputeds/1
  # PUT /disputeds/1.xml
  def update
    @disputed = Disputed.find(params[:id])
    validate_update_by_date(@disputed)

    respond_to do |format|
      if @disputed.update_attributes(params[:disputed])
        format.html { redirect_to(event_disputeds_url(@disputed.event), :notice => 'Спорный изменен.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /disputeds/1
  # DELETE /disputeds/1.xml
  def destroy
    @disputed = Disputed.find(params[:id])
    validate_update_by_date(@disputed)
    
    @disputed.destroy
    respond_to do |format|
      format.html { redirect_to(event_disputeds_url(@disputed.event), :notice => 'Спорный удален.') }
    end
  end
end