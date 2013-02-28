class InteriorHistory < ActiveRecord::Base
  belongs_to :interior
  attr_accessible :depth, :height, :start_date, :width

  default_scope :order => "start_date desc"

  before_save do |record|
    if record.start_date.blank?
      record.start_date = Date.today
    end
  end
end
