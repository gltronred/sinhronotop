class PlaysController < ApplicationController
  before_filter :load_parents
  before_filter :check_do_changes


  # POST /plays
  def create
    #add new player
    player = Player.new
    player.firstName = params[:firstName]
    player.lastName = params[:lastName]
    player.patronymic = params[:patronymic]
    player.team_id = params[:team][:id]
    player.save

    #add new play
    play = Play.new
    play.player_id = player.id
    play.event_id = params[:event_id]
    play.team_id = params[:team][:id]
    play.save

    redirect_to(event_casts_path(params[:event_id]), :notice => 'Игрок добавлен.')

  end

  def destroy
    play = Play.find(params[:id])
    event_id = play.event_id
    play.destroy
    redirect_to(event_casts_path(event_id), :notice => 'Игрок удален.')
  end

  def set_captain
    Play.update_all "status=''", "id <> #{params[:id]} AND team_id = #{params[:team_id]} AND event_id = #{params[:event_id]}"
    play = Play.find(params[:id])
    play.update_attribute :status, 'captain'

    respond_to do |format|
      format.js
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
