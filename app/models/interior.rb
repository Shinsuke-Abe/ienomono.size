class Interior < ActiveRecord::Base
  belongs_to :user
  has_many :interior_histories
  has_many :taggins
  has_many :category_tags, :through=>:taggins
  accepts_nested_attributes_for :interior_histories

  attr_accessible :name

  def latest_history
    interior_histories.first
  end
end
