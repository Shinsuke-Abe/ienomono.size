class InteriorHistory < ActiveRecord::Base
  belongs_to :interior
  attr_accessible :depth, :height, :start_date, :width
end
