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

    if @assets > 0 || @assets_yesterday > 0
      @asset_chg = (@assets/@assets_yesterday-1)*100
      @stocks_chg = (@stocks/@stocks_yesterday-1)*100
      @stock_weight = @stocks/@assets*100
    end

    @holdings.sort_by!{|holding| holding.weight(@assets)}.reverse!
    
    mail :to => user.email, :subject => "Portfolio Summary"
  end
end