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
    mail to: user.email, :subject => "Your Portfolio Performance"
  end
end