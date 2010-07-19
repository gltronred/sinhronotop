require 'event_subresources_controller'

class AppealsController < EventsSubresourcesController
  before_filter :load_parents

  # GET /appeals
  # GET /appeals.xml
  def index
    @appeal = Appeal.new
    @appeals = @parent.appeals    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /appeals/1/edit
  def edit
    @appeal = Appeal.find(params[:id])
  end

  # POST /appeals
  # POST /appeals.xml
  def create
    @appeal = Appeal.new(params[:appeal])
    validate_update_by_date(@appeal)
    
    respond_to do |format|
      if @appeal.save
        format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция сохранена.') }
      else
        format.html { render :action => "index" }
      end
    end
  end

  # PUT /appeals/1
  # PUT /appeals/1.xml
  def update
    @appeal = Appeal.find(params[:id])
    validate_update_by_date(@appeal)
    
    respond_to do |format|
      if @appeal.update_attributes(params[:appeal])
        format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция изменена.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /appeals/1
  # DELETE /appeals/1.xml
  def destroy
    @appeal = Appeal.find(params[:id])
    validate_update_by_date(@appeal)

    @appeal.destroy
    respond_to do |format|
      format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция удалена.') }
    end
  end
end