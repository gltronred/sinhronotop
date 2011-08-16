class PlaysController < ApplicationController
  before_filter :load_parents, :except => [:auto_complete]
  before_filter :check_do_changes, :except => [:auto_complete]


  # POST /plays
  def create

    @err_flag = false

    if params[:player_id].to_i > 0
      player = Player.find(params[:player_id].to_i)
      if !player
          flash[:notice] = "Не удалось найти игрока."
          @err_flag = true
      end
    else
      #add new player
      player = Player.new
      player.firstName = params[:firstName]
      player.lastName = params[:lastName]
      player.patronymic = params[:patronymic]
      player.team_id = params[:team][:id]
      if !player.save
        flash[:notice] = player.errors.full_messages.to_sentence
        @err_flag = true
      end
    end

    # if no errors - add player to play
    if !@err_flag
      params[:player_id] = player.id
      if Play.is_player_in_play(params).size > 0
        @err_flag = true
        flash[:notice] = 'Игрок уже добавлен в команду.'
      else
        play = Play.new
        play.player_id = player.id
        play.event_id = params[:event_id]
        play.team_id = params[:team][:id]
        play.save
        flash[:notice] = 'Игрок добавлен.'
      end
    end

    @messages_block = "<p class=\"message\">#{flash[:notice]}</p>"
    respond_to do |format|
      format.js {render :partial => 'play_error', :content_type => 'text/javascript'}
    end
  end

  def destroy
    play = Play.find(params[:id])
    event_id = play.event_id
    play.destroy
    redirect_to(event_casts_path(event_id), :notice => 'Игрок удален.')
  end

  def set_captain
    Play.update_all(
        {:status => ""},
        ['id <> ? AND team_id = ? AND event_id = ?', params[:id], params[:team_id], params[:event_id]]
      )

    play = Play.find(params[:id])
    play.update_attribute :status, 'captain'
    respond_to do |format|
      format.js
    end
  end

  def auto_complete
    ActiveRecord::Base.include_root_in_json = false
    @players = Player.autocomplete(params)
    render :json => @players.to_json(
        :except => [:created_at, :updated_at]
    )
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
