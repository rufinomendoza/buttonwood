class User < ActiveRecord::Base
  # attr_accessible :email, :password_hash, :password_salt
  attr_accessible :email, :password, :password_confirmation

  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :portfolios, :dependent => :destroy
  has_many :securities, :dependent => :destroy
  has_many :sectors, :dependent => :destroy
  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end


end

class Format
  # Formatting across the 

  def self.currency(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 0)
  end

  def self.currency_dec(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 2)
  end  

  def self.comma(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "", :precision => 0)
  end
  
  def self.comma_dec(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "", :precision => 2)
  end

  def self.percent(n)
    ActionController::Base.helpers.number_to_percentage(n, :precision => 0)
  end

  def self.percent_dec(n)
    ActionController::Base.helpers.number_to_percentage(n, :precision => 2)
  end
end