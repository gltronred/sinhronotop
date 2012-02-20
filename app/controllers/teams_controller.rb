class TeamsController < ApplicationController
  before_filter :check_duplicates, :only => [:duplicates, :merge]

  def duplicates
    @teams_all = Team.find(:all).sort_by{|t| t.name }
    @teams_no_rating = Team.find(:all, :conditions => "rating_id is null or rating_id < 0").sort_by{|t| t.name }
  end
  
  def merge
    real = Team.find_by_id params[:real]
    duplicate = Team.find_by_id params[:duplicate]
    Team.merge(real, duplicate)
    respond_to do |format|
      if Team.merge(real, duplicate)
        format.html { redirect_to(duplicates_path, :notice => 'ОК') }
      else
        flash[:error] = real.errors.full_messages
        format.html { render :action=>"duplicates", :controller=>"teams" }
      end
    end
  end

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
  
  protected

  def check_duplicates
    check_permissions { is_admin? }
  end
  
end
