class Interior < ActiveRecord::Base
  belongs_to :user
  has_many :interior_histories
  accepts_nested_attributes_for :interior_histories

  attr_accessible :name

  def latest_history
    interior_histories.order("start_date DESC").first
  end
end
