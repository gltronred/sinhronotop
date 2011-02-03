class ResultitemsController < ApplicationController

  before_filter :load_parents
  before_filter :check_do_changes, :only => [:create, :update, :destroy]
  
  # POST /resultitems
  # POST /resultitems.xml
  def create
    @resultitem = Resultitem.new(params[:resultitem])
    respond_to do |format|
      if @resultitem.save
        format.html { redirect_to(@resultitem, :notice => 'Resultitem was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /resultitems/1
  # PUT /resultitems/1.xml
  def update
    @resultitem = Resultitem.find(params[:id])
    @resultitem.score = params[:checked]
    @resultitem.save
    @result = @resultitem.result
    @result.calculate_and_save
    respond_to do |format|
      format.js
    end
  end

  # DELETE /resultitems/1
  # DELETE /resultitems/1.xml
  def destroy
    @resultitem = Resultitem.find(params[:id])
    @resultitem.destroy
    respond_to do |format|
      format.html { redirect_to(resultitems_url) }
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
