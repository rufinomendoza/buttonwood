desc "This task is called by the Heroku scheduler add-on"

task :mail_holdings => :environment do
  users = User.all
  users.each do |user|
    UserMailer.mail_holdings(user).deliver
  end
end