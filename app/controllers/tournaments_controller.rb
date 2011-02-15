class TournamentsController < ApplicationController

  before_filter :check_create_or_destroy, :only => [:new, :create, :destroy]
  before_filter :find, :only => [:update, :edit, :destroy, :results, :show ]
  before_filter :check_update, :only => [:edit, :update]

  # GET /tournaments
  # GET /tournaments.xml
  def index
    @tournaments = Tournament.all
    respond_to do |format|
      @context_array = ["Все турниры"]
      format.html # index.html.erb
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    respond_to do |format|
      @context_array = [@tournament]
      format.html # show.html.erb
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @tournament = Tournament.new
    load_cities
    load_users
    @context_array = ["Новый турнир"]
  end

  # GET /tournaments/1/edit
  def edit
    load_users
    load_cities
    @context_array = [@tournament, "изменить настройки"]
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @tournament = Tournament.new(params[:tournament])
    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(@tournament, :notice => 'Турнир создан') }
      else
        format.html {
          load_cities
          render :action => "new"
        }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to(@tournament, :notice => 'Настройки турнира изменены') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to(tournaments_url, :notice => 'Турнир удален') }
    end
  end

  def results
    @context_array = [@tournament, "поэтапные результаты"]
    @teams = @tournament.get_teams
    @games = @tournament.games.reject{|game|!game.publish_results}.sort{|x,y|x.end <=> y.end}
  end

  protected

  def load_cities
    @cities = City.all(:order => :name)
  end

  def find
    @tournament = Tournament.find params[:id]
    unless @tournament
      flash[:notice] = "Турнир с id #{id} не найден"
      redirect_to home_path
    end
  end

  def check_create_or_destroy
    check_permissions { is_admin? }
  end
  
  def check_update
    check_permissions { is_org?(@tournament) }
  end

end
