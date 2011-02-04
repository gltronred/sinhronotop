class ResultitemsController < ApplicationController

  before_filter :load_resultitem_with_parents
  before_filter :check_do_changes

  # PUT /resultitems/1
  # PUT /resultitems/1.xml
  def update
    @resultitem.score = params[:checked]
    @resultitem.save
    @result.calculate_and_save
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def load_resultitem_with_parents
    @resultitem = Resultitem.find(params[:id])
    @result = @resultitem.result
    @event = @result.event
    @game = @event.game
  end
  
  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_results? @event}
    else
      check_permissions{can_see_results? @game}
    end
  end
  
end
