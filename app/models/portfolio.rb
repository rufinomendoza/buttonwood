class Portfolio < ActiveRecord::Base
  attr_accessible :user_id, :name, :ips, :cash
  belongs_to :user
  has_many :holdings, :dependent => :destroy
  has_many :securities, :through => :holdings, :dependent => :destroy

  validates :name, :uniqueness => { :scope => :user_id }
  validates :cash, :presence => true

  def weight(assets)
    Format.percent_dec(cash/assets*100)
  end

end
