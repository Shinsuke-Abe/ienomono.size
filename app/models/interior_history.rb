class InteriorHistory < ActiveRecord::Base
  belongs_to :interior, touch: true
  attr_accessible :depth, :height, :start_date, :width, :memo_text

  default_scope :order => "start_date desc, created_at desc"

  validate :input_size_data_at_least_one
  validates :width, :height, :depth, numericality: {greater_than_or_equal_to: 0.1}, allow_blank: true

  before_save do |record|
    if record.start_date.blank?
      record.start_date = Date.today
    end
  end

  def input_size_data_at_least_one
    if depth.blank? and height.blank? and width.blank?
      errors.add(:depth, "input at least one")
      errors.add(:height, "input at least one")
      errors.add(:width, "input at least one")
    end
  end
end
