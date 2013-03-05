class Tagging < ActiveRecord::Base
  belongs_to :interior
  belongs_to :category_tag
  # attr_accessible :title, :body
end
