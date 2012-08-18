class Holding < ActiveRecord::Base
  attr_accessible :portfolio_id, :security_id, :shares_held
  belongs_to :portfolios
  belongs_to :securities
end
