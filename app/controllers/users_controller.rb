class UsersController < ApplicationController
  skip_before_filter :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      initial_setup
      redirect_to log_in_url, :notice => "Thank you for signing up.  Please log in below."
    else
      render "new"
    end
  end

  def index
    @users = User.where("id = ?", current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to my_account_url, notice: 'Your account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    cookies.delete(:auth_token)
    respond_to do |format|
      format.html { redirect_to home_url, :notice => "Sorry to see you go!" }
      format.json { head :no_content }
    end
  end

  private

  def initial_setup
    sectors = ["Energy","Materials","Industrials","Consumer Discretionary","Consumer Staples","Health Care","Financials","Information Technology","Telecommunication Services","Utilities"]
    sectors.each do |name|
      @sector = Sector.new(params[:sector])
      @sector.name = name
      @sector.user_id = @user.id
      @sector.save
    end

    @security = Security.new(params[:security])
    s = "Information Technology"
    sector_id = Sector.where("user_id = ?", @user.id)
    link = sector_id.find_by_name(s)
    @security.user_id = @user.id
    @security.sector_id = link.id
    @security.our_price_target = 700
    @security.symbol = "AAPL"
    @security.save

    @portfolio = Portfolio.new(params[:portfolio])
    @portfolio.user_id = @user.id
    @portfolio.name = "Starter Portfolio"
    @portfolio.cash = 1000
    @portfolio.save

    @holding = Holding.new(params[:holding])
    @holding.portfolio_id = @portfolio.id
    @holding.security_id = @security.id
    @holding.shares_held = 100
    @holding.save
  end

end
