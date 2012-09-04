class HoldingsController < ApplicationController

  # GET /holdings
  # GET /holdings.json
  def index
    @holdings = Holding.joins(:portfolio).where("user_id = ?", current_user.id)

    @portfolios = Portfolio.where("user_id = ?", current_user.id)
    
    @stocks = []
    @liquid = []
    @holdings.each do |holding| 
      @stocks << holding.dollar_value
    end
    @portfolios.each do |portfolio| 
      @liquid << portfolio.cash
    end
    @stocks = @stocks.sum
    @liquid = @liquid.sum 
    @assets = @stocks + @liquid

    @stocks_yesterday = [] 
    @holdings.each do |holding| 
      @stocks_yesterday << holding.dollar_value_yesterday 
    end
    @stocks_yesterday = @stocks_yesterday.sum
    @assets_yesterday = @stocks_yesterday + @liquid

    @stock_weight = @stocks/@assets*100

    if @assets > 0 || @assets_yesterday > 0
      @asset_chg = (@assets/@assets_yesterday-1)*100
      @stocks_chg = (@stocks/@stocks_yesterday-1)*100
    end

    @holdings.sort_by!{|holding| holding.weight(@assets)}.reverse!
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
end
