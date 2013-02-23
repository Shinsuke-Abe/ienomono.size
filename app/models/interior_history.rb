class InteriorHistory < ActiveRecord::Base
  belongs_to :interior
  attr_accessible :depth, :height, :start_date, :width

  default_scope :order => "start_date desc"
end
