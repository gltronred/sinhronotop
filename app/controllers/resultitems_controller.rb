class ResultitemsController < ApplicationController
  # GET /resultitems
  # GET /resultitems.xml
  def index
    @resultitems = Resultitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resultitems }
    end
  end

  # GET /resultitems/1
  # GET /resultitems/1.xml
  def show
    @resultitem = Resultitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resultitem }
    end
  end

  # GET /resultitems/new
  # GET /resultitems/new.xml
  def new
    @resultitem = Resultitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resultitem }
    end
  end

  # GET /resultitems/1/edit
  def edit
    @resultitem = Resultitem.find(params[:id])
  end

  # POST /resultitems
  # POST /resultitems.xml
  def create
    @resultitem = Resultitem.new(params[:resultitem])

    respond_to do |format|
      if @resultitem.save
        format.html { redirect_to(@resultitem, :notice => 'Resultitem was successfully created.') }
        format.xml  { render :xml => @resultitem, :status => :created, :location => @resultitem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resultitem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resultitems/1
  # PUT /resultitems/1.xml
  def update
    @resultitem = Resultitem.find(params[:id])
    @resultitem.score =  (params[:checked])
    @resultitem.save
    @result = @resultitem.result
    @result.calculate_and_save
    respond_to do |format|
      format.js
    end
  end

  # DELETE /resultitems/1
  # DELETE /resultitems/1.xml
  def destroy
    @resultitem = Resultitem.find(params[:id])
    @resultitem.destroy

    respond_to do |format|
      format.html { redirect_to(resultitems_url) }
      format.xml  { head :ok }
    end
  end
end
