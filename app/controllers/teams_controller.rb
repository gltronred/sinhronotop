class TeamsController < ApplicationController

  # POST /teams
  # POST /teams.xml
  def create
    input_for_team = params[:team].except(:event_id)
    input_for_team[:rating_id] = [Team.minimum(:rating_id) - 1, -1].min
    @team = Team.new(input_for_team)

    @result = Result.new
    @result.team = @team
    @result.cap_name = params[:cap_name]
    @result.score = 0
    @result.local_index = params[:local_index]
    @result.event_id = params[:team][:event_id]

    respond_to do |format|
      if @team.valid? && @result.valid?
        @team.save && @result.save
        @result.create_resultitems
        @result.event.shift_local_indexes(@result, true)
        format.html { redirect_to(event_results_path(@result.event), :notice => 'Команда добавлена') }
      else
        format.html { redirect_to(event_results_path(@result.event), :notice => @team.e_to_s + " <br/> " + @result.e_to_s) }
      end
    end
  end

end
