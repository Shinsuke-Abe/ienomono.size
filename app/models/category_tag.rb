class CategoryTag < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :interiors, through: :taggings
  attr_accessible :name

  scope :enable_tags, ->(user = nil) do
    if user.blank?
      {conditions: ["user_id is null"]}
    else
      {conditions: ["user_id is null or user_id = ?", user.id]}
    end
  end

  def self.find_tag(tag_name, user = nil)
    enable_tags(user).where("name = ?", tag_name).first
  end
end
