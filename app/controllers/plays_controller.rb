class PlaysController < ApplicationController
  before_filter :load_parents, :except => [:auto_complete]
  before_filter :check_do_changes, :except => [:auto_complete]


  # POST /plays
  def create
    #add new player
    player = Player.new
    player.firstName = params[:firstName]
    player.lastName = params[:lastName]
    player.patronymic = params[:patronymic]
    player.team_id = params[:team][:id]


    # @TODO: maybe this block could be refactored
    if player.save
        #add new play
        play = Play.new
        play.player_id = player.id
        play.event_id = params[:event_id]
        play.team_id = params[:team][:id]
        play.save
        #redirect_to(event_casts_path(params[:event_id]), :notice => 'Игрок добавлен.')
        flash[:notice] = 'Игрок добавлен.'
        @err_flag = false
    else
       flash[:notice] = player.errors.full_messages.to_sentence
       @err_flag = true
     end

    #@messages_block = render :partial => "layouts/mesages"
    @messages_block = "<p class=\"message\">#{flash[:notice]}</p>"
    respond_to do |format|
      format.js {render :partial => 'play_error', :content_type => 'text/javascript'}
    end
    # @TODO: maybe this block could be refactored

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

  def auto_complete
    ActiveRecord::Base.include_root_in_json = false
    @players = Player.find(
                          :all,
                          :conditions => ["lastName LIKE ?", params[:lastName].to_s + '%'],
                          :order => "lastName, firstName, patronymic"
    )
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
