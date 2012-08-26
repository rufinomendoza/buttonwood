class Sector < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :securities, :dependent => :destroy

  validates_uniqueness_of :name, :scope => :user_id
  validates :name, :presence => true
end
