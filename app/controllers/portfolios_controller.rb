class PortfoliosController < ApplicationController
  # GET /portfolios
  # GET /portfolios.json
  def index
    @portfolios = Portfolio.where("user_id = ?", current_user.id)
    # @holdings = Holding.joins(:portfolio).where("user_id = ?", current_user.id)

    # @assets = []
    # @holdings.each do |holding| 
    #   @assets << holding.dollar_value
    # end 
    # @portfolios.each do |portfolio| 
    #   @assets << portfolio.cash
    # end 
    # @assets = @assets.sum 

    # @assets_yesterday = [] 
    # @holdings.each do |holding| 
    #   @assets_yesterday << holding.dollar_value_yesterday 
    # end
    # @portfolios.each do |portfolio| 
    #   @assets_yesterday << portfolio.cash
    # end 
    # @assets_yesterday = @assets_yesterday.sum

    # if @assets > 0 || @assets_yesterday > 0
    #   @chg = (@assets/@assets_yesterday-1)*100
    # end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    @portfolio = Portfolio.find(params[:id])
  end

  # GET /portfolios/new
  # GET /portfolios/new.json
  def new
    @portfolio = Portfolio.new
  end

  # GET /portfolios/1/edit
  def edit
    @portfolio = Portfolio.find(params[:id])
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(params[:portfolio])
    @portfolio.user_id = current_user.id
    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully created.' }
        format.json { render json: @portfolio, status: :created, location: @portfolio }
      else
        format.html { render action: "new" }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /portfolios/1
  # PUT /portfolios/1.json
  def update
    @portfolio = Portfolio.find(params[:id])

    respond_to do |format|
      if @portfolio.update_attributes(params[:portfolio])
        format.html { redirect_to @portfolio, notice: 'Portfolio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @portfolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy

    respond_to do |format|
      format.html { redirect_to portfolios_url }
      format.json { head :no_content }
    end
  end
end
