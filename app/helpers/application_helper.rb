# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def authenticate
    unless logged_in?
      store_location
      render "home/index"
    end
  end

  def cut_by_sign(str, sign)
    if str
      index = str.index(sign)
      index ? "#{str[0..index-1]}#{"..." if str.length>index}" : "#{str}"
    else
      nil
    end
  end

  def cut_by_count(str, count)
    str ? "#{str[0..count-1]}#{"..." if str.length>count}" : nil
  end


  def load_parents
    event_id = params[:event_id]
    [:appeal, :disputed, :result].each do |first_key|
      event_id ||= params[first_key][:event_id] if !event_id && params.has_key?(first_key)
    end
    event_id ||= params[:resultitem][:result][:event_id] if !event_id && params[:resultitem] && params[:resultitem][:result]
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

  def load_users
    @users = User.all(:order => :name).select{|u| 'znatok' != u.status}
  end

  def context_array(arr)
    arr.map{|element| element.is_a?(String) ? element : link_to(element.to_s, element)}.join(' >> ')
  end

  @@converters = {
    'ISO-8859-5' => Iconv.new('ISO-8859-5', 'UTF-8'),
    'UTF-8' => Iconv.new('UTF-8', 'UTF-8'),
    'KOI8-R' => Iconv.new('KOI8-R', 'UTF-8')
  }

  def get_converters_array
    @@converters.keys
  end

end
