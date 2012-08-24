class Portfolio < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :users
  has_many :holdings, :dependent => :destroy
  has_many :securities, :through => :holdings, :dependent => :destroy
end
