class AppealsController < ApplicationController

  before_filter :load_parents
  before_filter :check_do_changes, :only => [:index, :edit, :create, :update, :destroy]

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
  end

  # POST /appeals
  # POST /appeals.xml
  def create
    @appeal = Appeal.new(params[:appeal])
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
    @appeal.destroy
    respond_to do |format|
      format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция удалена.') }
    end
  end
  
  private 
  
  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_appeal? @event}
    else
      check_permissions{can_see_appeal? @game}
    end
  end
  
end
