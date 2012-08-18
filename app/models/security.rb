class Security < ActiveRecord::Base
  attr_accessible :name, :symbol
  has_many :holdings
  has_many :portfolios, :through => :holdings
end
