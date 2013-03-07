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

  def self.find_tag(tag_name, user = nil)
    if user
      find(:all, conditions: ["(user_id is null or user_id = ?) and name = ?", user.id, tag_name]).first
    else
      find(:all, conditions: ["user_id is null and name = ?", tag_name]).first
    end
  end
end
