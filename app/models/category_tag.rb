class CategoryTag < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :interiors, through: :taggings
  attr_accessible :name

  scope :enable_tags, lambda {|user = nil|
    user.blank? ? {conditions: ["user_id is null"]} : {conditions: ["user_id is null or user_id = ?", user.id]}
  }

  def self.find_tag(tag_name, user = nil)
    self.enable_tags(user).where("name = ?", tag_name).first
  end
end
