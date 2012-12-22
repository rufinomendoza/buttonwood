class Security < ActiveRecord::Base
  attr_accessible :user_id, :sector_id, :symbol, :our_price_target, :our_current_year_eps, :our_next_year_eps
  belongs_to :user
  belongs_to :sector
  
  has_many :holdings, :dependent => :destroy
  has_many :portfolios, :through => :holdings, :dependent => :destroy

  validates :symbol, :uniqueness => { :scope => :user_id, :case_sensitive => false }, :presence => true
  validates :sector_id, :presence => true

  def sector_name
    sector.name
  end

  def fmt_price_target
    Format.currency_dec(our_price_target)
  end

  def fmt_current_year_eps
    Format.currency_dec(our_current_year_eps)
  end

  def fmt_next_year_eps
    Format.currency_dec(our_next_year_eps)
  end
    

end