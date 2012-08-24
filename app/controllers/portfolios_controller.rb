class PortfoliosController < ApplicationController
  # GET /portfolios
  # GET /portfolios.json
  def index
    @portfolios = Portfolio.all

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
    #raise params.inspect
    #@current_user.id
    
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
