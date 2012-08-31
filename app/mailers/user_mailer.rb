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

    mail to: user.email, :subject => "Portfolio Summary"
  end
end