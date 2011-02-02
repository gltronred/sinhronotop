class AppealsController < EventSubresourcesController
  include PermissionHelper

  before_filter :load_parents

  # GET /appeals
  # GET /appeals.xml
  def index
    @appeal = Appeal.new
    @appeals = @parent.appeals.sort {|x,y| x.question_index <=> y.question_index}
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /appeals/1/edit
  def edit
    @appeal = Appeal.find(params[:id])
    event = Event.find_by_id(@appeal.event_id);
    do_event_changes(event) {event.is_modifiable? 'appeal'}
    #modify_event_results?(@appeal.event, 'appeal', true)
  end

  # POST /appeals
  # POST /appeals.xml
  def create
    @appeal = Appeal.new(params[:appeal])
    @event = Event.find_by_id(@appeal.event_id)
    @game = @event.game
    do_event_changes(@event) {@event.is_modifiable? 'appeal'}
    #modify_event_results?(@event, 'appeal', true)
    respond_to do |format|
      if @appeal.save
        format.html {
          @appeals = @event.appeals
          redirect_to(event_appeals_url(@event), :notice => 'Апелляция сохранена.')
        }
      else
        @appeals = @event.appeals
        format.html { render :action => "index" }
      end
    end
  end

  # PUT /appeals/1
  # PUT /appeals/1.xml
  def update
    @appeal = Appeal.find(params[:id])
    event = Event.find_by_id(@appeal.event_id)
    do_event_changes(event) {event.is_modifiable? 'appeal'}
    respond_to do |format|
      if @appeal.update_attributes(params[:appeal])
        format.html { redirect_to(event_appeals_url(event), :notice => 'Апелляция изменена.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /appeals/1
  # DELETE /appeals/1.xml
  def destroy
    @appeal = Appeal.find(params[:id])
    event = Event.find_by_id(@appeal.event_id)
    do_event_changes(event) {event.is_modifiable? 'appeal'}
    @appeal.destroy
    respond_to do |format|
      format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция удалена.') }
    end
  end
end
