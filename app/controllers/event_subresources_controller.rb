class EventSubresourcesController < ApplicationController
  
  def load_parents
    event_id = params[:event_id]
    if event_id
      @parent = @event = Event.find(event_id)
      @game = @event.game
    else
      game_id = params[:game_id]
      if game_id
        @parent = @game = Game.find_by_id(game_id)
      end
    end
  end
end