class Interior < ActiveRecord::Base
  belongs_to :user
  has_many :interior_histories
  has_many :taggings
  has_many :category_tags, :through=>:taggings
  accepts_nested_attributes_for :interior_histories

  attr_accessible :name, :joined_tags
  attr_accessor :joined_tags

  after_initialize :do_as_after_initialize

  def do_as_after_initialize
    self.joined_tags ||= tags_string
  end

  def latest_history
    interior_histories.first
  end

  def tags_string
    category_tags.map{|tag| tag.name}.join(",")
  end
end
