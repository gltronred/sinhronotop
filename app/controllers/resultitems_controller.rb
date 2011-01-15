class ResultitemsController < ApplicationController
  include PermissionHelper

  #before_filter :authenticate

  # POST /resultitems
  # POST /resultitems.xml
  def create
    @resultitem = Resultitem.new(params[:resultitem])
    modify_event_results?(@resultitem.result.event, 'results', true)    
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
    modify_event_results?(@resultitem.result.event, 'results', true)        
    @resultitem.score =  (params[:checked])
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
    modify_event_results?(@resultitem.result.event, 'results', true)        
    @resultitem.destroy
    respond_to do |format|
      format.html { redirect_to(resultitems_url) }
    end
  end
end
