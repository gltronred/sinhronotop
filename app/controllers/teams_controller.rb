class TeamsController < ApplicationController
  
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    input_for_team = params[:team].except("event_id")
    @team = Team.new(input_for_team)

    respond_to do |format|
      if @team.save
          input_for_result = params[:team].except("name")
          input_for_result["team_id"] = @team.id
          input_for_result["score"] = 0
          @result = Result.new(input_for_result)
          @result.save
          @result.create_resultitems
          format.html { redirect_to(event_results_path(@result.event), :notice => 'Команда добавлена') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to(@team, :notice => 'Данные команды обновлены') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
    end
  end
end
