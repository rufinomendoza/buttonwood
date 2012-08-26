class Security < ActiveRecord::Base
  attr_accessible :user_id, :sector_id, :symbol, :our_price_target, :our_current_year_eps, :our_next_year_eps
  belongs_to :user
  belongs_to :sector
  
  has_many :holdings, :dependent => :destroy
  has_many :portfolios, :through => :holdings, :dependent => :destroy

  validates :symbol, :uniqueness => { :scope => :user_id, :case_sensitive => false }
  validates :sector_id, :presence => true
  validates :our_price_target, :presence => true

  def sector_name
    sector.name
  end
end