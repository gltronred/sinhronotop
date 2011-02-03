# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def authenticate
    render "home/index" unless logged_in?
  end
  def eu_date(date)
    date.strftime('%d.%m.%Y')
  end
  def load_parents
    event_id = params[:event_id]
    [:appeal, :disputed, :result].each do |first_key|
      event_id ||= params[first_key][:event_id] if !event_id && params.has_key?(first_key)
    end
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
