class HoldingsController < ApplicationController

  helper_method :sort_column, :sort_direction

  # GET /holdings
  # GET /holdings.json
  def index
    @holdings = Holding.joins(:portfolio).where("user_id = ?", current_user.id).order(sort_column + ' ' + sort_direction)

    @assets = []
    @holdings.each do |holding| 
      @assets << holding.dollar_value
    end 
    @assets = @assets.sum 

    @assets_yesterday = [] 
    @holdings.each do |holding| 
      @assets_yesterday << holding.dollar_value_yesterday 
    end 
    @assets_yesterday = @assets_yesterday.sum

    if @assets > 0 || @assets_yesterday > 0
      @chg = (@assets/@assets_yesterday-1)*100
    end
  end

  # GET /holdings/1
  # GET /holdings/1.json
  def show
    @holding = Holding.find(params[:id])
  end

  # GET /holdings/new
  # GET /holdings/new.json
  def new
    @holding = Holding.new
  end

  # GET /holdings/1/edit
  def edit
    @holding = Holding.find(params[:id])
  end

  # POST /holdings
  # POST /holdings.json
  def create
    @holding = Holding.new(params[:holding])
    respond_to do |format|
      if @holding.save
        format.html { redirect_to holdings_url, notice: 'Holding was successfully created.' }
        format.json { render json: @holding, status: :created, location: @holding }
      else
        format.html { render action: "new" }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /holdings/1
  # PUT /holdings/1.json
  def update
    @holding = Holding.find(params[:id])
    respond_to do |format|
      if @holding.update_attributes(params[:holding])
        format.html { redirect_to holdings_url, notice: 'Holding was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holdings/1
  # DELETE /holdings/1.json
  def destroy
    @holding = Holding.find(params[:id])
    @holding.destroy

    respond_to do |format|
      format.html { redirect_to holdings_url }
      format.json { head :no_content }
    end
  end

  def sort_asc
    @holdings.sort_by!{|holding| holding.indicator("Name")}
  end

  def sort_desc(method)
    @holdings.sort_by!{|holding| method}.reverse!
  end

  private

  def sort_column
     Holding.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

end