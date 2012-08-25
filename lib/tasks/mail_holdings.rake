task :mail_holdings => :environment do
  users = User.all
  users.each do |user|
    UserMailer.mail_holdings(user).deliver
  end
end