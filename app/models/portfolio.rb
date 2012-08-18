class Portfolio < ActiveRecord::Base
  attr_accessible :name
  has_many :holdings
  has_many :securities, :through => :holdings
end
