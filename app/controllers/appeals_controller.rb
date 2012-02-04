class AppealsController < ApplicationController

  before_filter :load_appeal_with_parents, :only => [:edit, :update, :destroy]
  before_filter :load_parents, :only => [:create, :index, :appeals_and_controversial]
  before_filter :check_do_changes

  # GET /appeals
  # GET /appeals.xml
  def index
    @appeal = Appeal.new #test
    @appeals = @parent.appeals.sort{|x,y| x.question_index <=> y.question_index}
    respond_to do |format|
      @context_array = @parent.parents_top_down(:with_me) << "апелляции (#{@appeals.size})"
      format.html # index.html.erb
      format.csv
      format.txt
    end
  end

  # GET /appeals/1/edit
  def edit
    @context_array = @appeal.parents_top_down << "изменить апелляцию"
  end

  # POST /appeals
  # POST /appeals.xml
  def create
    @appeal = Appeal.new(params[:appeal])
    respond_to do |format|
      format.html {
        if @appeal.save
          redirect_to(event_appeals_url(@event), :notice => 'Апелляция сохранена.')
        else
          redirect_to(event_appeals_url(@event), :notice => @appeal.e_to_s)
        end
      }
    end
  end

  # PUT /appeals/1
  # PUT /appeals/1.xml
  def update
    respond_to do |format|
      if @appeal.update_attributes(params[:appeal])
        format.html { redirect_to(event_appeals_url(@event), :notice => 'Апелляция изменена.') }
      else
        format.html { redirect_to(event_appeals_url(@event), :notice => @appeal.e_to_s) }
      end
    end
  end

  # DELETE /appeals/1
  # DELETE /appeals/1.xml
  def destroy
    @appeal.destroy
    respond_to do |format|
      format.html { redirect_to(event_appeals_url(@appeal.event), :notice => 'Апелляция удалена.') }
    end
  end

  def appeals_and_controversial
    @appeals = @parent.appeals.sort{|x,y| x.question_index <=> y.question_index}
    @disputeds = @parent.disputeds.sort {|x,y| x.question_index <=> y.question_index}

    @export_data = []
    @appeals.each do |appeal|
      @export_data[appeal.question_index] = {:appeals=> [],:disputes => [], :q_index => ''} if @export_data[appeal.question_index].nil?

      @export_data[appeal.question_index][:appeals] << {
                                                        :answer => appeal.answer,
                                                        :argument => appeal.argument,
                                                        :goal => appeal.goal
                                                      }
      @export_data[appeal.question_index][:q_index] = appeal.question_index
    end

    @disputeds.each do |disputed|
      @export_data[disputed.question_index] = {:appeals=> [],:disputes => [], :q_index => ''} if @export_data[disputed.question_index].nil?
      @export_data[disputed.question_index][:disputes] << {:answer => disputed.answer}
      @export_data[disputed.question_index][:q_index] = disputed.question_index
    end
    @context_array = @parent.parents_top_down(:with_me) << "апелляции (#{@appeals.size}) и спорные (#{@disputeds.size})"
    send_data render('appeals_and_controversial.txt', :layout => false),
              :filename => 'appeals_and_controversial.txt',
              :disposition => 'attachment',
              :type => "text/plain; charset=utf-8",
              :encoding => 'utf-8'
  end

  private
  
  def load_appeal_with_parents
    @appeal = Appeal.find(params[:id])
    @event = @appeal.event
    @game = @event.game
  end

  def check_do_changes
    if @event
      check_time_constrains(@event) {can_submit_appeal? @event}
    else
      check_permissions{can_see_appeal? @game}
    end
  end

end
