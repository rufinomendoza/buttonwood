class Security < ActiveRecord::Base
  attr_accessible :our_sector, :symbol, :our_price_target, :our_current_year_eps, :our_next_year_eps
  has_many :holdings, :dependent => :destroy
  has_many :portfolios, :through => :holdings, :dependent => :destroy

  validates :symbol, :uniqueness => true
end
