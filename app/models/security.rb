class Security < ActiveRecord::Base
  attr_accessible :user_id, :our_sector, :symbol, :our_price_target, :our_current_year_eps, :our_next_year_eps
  belongs_to :user
  has_many :holdings, :dependent => :destroy
  has_many :portfolios, :through => :holdings, :dependent => :destroy

  validates :symbol, :uniqueness => { :scope => :user_id, :case_sensitive => false }
  validates :our_price_target, :presence => true
  
end