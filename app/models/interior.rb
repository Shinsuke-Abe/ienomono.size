class Interior < ActiveRecord::Base
  belongs_to :user
  has_many :interior_histories
  has_many :taggings
  has_many :category_tags, :through=>:taggings
  accepts_nested_attributes_for :interior_histories

  attr_accessible :name, :joined_tags, :interior_histories_attributes
  attr_accessor :joined_tags

  scope :list_users_have, ->(user = nil) do
    if user.present? and user.id.present?
      {conditions: ["user_id = ?", user.id]}
    end
  end

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

  def self.search_by_tagging(user, tag_list)
    list_users_have(user).joins(:taggings).where("taggings.category_tag_id in (?)", tag_list).uniq
  end

  def self.search_by_memo_text(user, search_text)
    list_users_have(user).joins(:interior_histories).where("interior_histories.memo_text like ?", "%#{search_text}%").uniq
  end
end
