class Portfolio < ActiveRecord::Base
  attr_accessible :user_id, :name, :ips
  belongs_to :user
  has_many :holdings, :dependent => :destroy
  has_many :securities, :through => :holdings, :dependent => :destroy

  validates :name, :uniqueness => true
end
