class EventsSubresourcesController < ApplicationController
  def load_parents
    event_id = params[:event_id]
    if !event_id.nil?
      @parent = @event = Event.find(event_id)
      @game = @event.game
    else
      game_id = params[:game_id]
      if !game_id.nil?
        @parent = @game = Game.find_by_id(game_id)
      end
    end
  end
  
  def validate_update_by_date(subresource)
    @game = Event.find(subresource.event_id).game
    if !@game.isSubChangeable(subresource)
      render :action => "../common/expired"
    end
  end
end