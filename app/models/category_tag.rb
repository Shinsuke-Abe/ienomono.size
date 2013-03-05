class CategoryTag < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :interiors, :through=>:taggings
  attr_accessible :name

  def self.enable_tags(user = nil)
    if user
      find(:all, conditions: ["user_id is null or user_id = ?", user.id])
    else
      find(:all, conditions: ["user_id is null"])
    end
  end
end
