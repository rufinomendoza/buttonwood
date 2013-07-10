class UserMailer < ActionMailer::Base

  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, :subject => "Password Reset"
  end

  def mail_holdings(user)
    @user = user
    @holdings = Holding.joins(:portfolio).where("user_id = ?", @user.id)

    @portfolios = Portfolio.where("user_id = ?", user.id)
    
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

    if @stocks > 0 || @stocks_yesterday > 0
      @stocks_chg = (@stocks/@stocks_yesterday-1)*100
    end

    if @assets > 0 || @assets_yesterday > 0
      @asset_chg = (@assets/@assets_yesterday-1)*100
      @stock_weight = @stocks/@assets*100
    end

    @agg_eps = []
    @agg_px = []
    @agg_bv = []

    @holdings.each do |holding|
      wavg_eps = holding.eps * holding.weight(@stocks)
      wavg_px = holding.last_px * holding.weight(@stocks)
      wavg_bv =  holding.bv * holding.weight(@stocks)
      @agg_eps << wavg_eps
      @agg_px << wavg_px
      @agg_bv << wavg_bv
    end

    @agg_eps = @agg_eps.sum
    @agg_px = @agg_px.sum
    @agg_bv = @agg_bv.sum

    if @agg_bv > 0 || @agg_eps > 0
      @agg_pe = @agg_px / @agg_eps
      @agg_pb = @agg_px / @agg_bv
    end

    @holdings.sort_by!{|holding| holding.weight(@assets)}.reverse!
    
    mail :to => user.email, :subject => "Portfolio Summary"
  end

  def gps
    gps_id = User.where("email = ?", "rlmendoza@aol.com").first.id
    portfolios = Portfolio.where("user_id =?", gps_id)
    @gps_holdings = []
    portfolios.each do |p|
      holdings = Holding.where("portfolio_id = ?", p.id)
      holdings.each {|h| @gps_holdings.append(h)}
    end

    puts @gps_holdings
    # @gps_holdings = Holding.joins(:portfolio).where("user_id = ?", current_user_id)
    # @gps_holdings.each do |holding|
    #   puts holding.symbol
    # end
  end

end