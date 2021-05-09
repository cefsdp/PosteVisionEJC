class Phase < ApplicationRecord
  belongs_to :etude
  has_many :intervenants, dependent: :destroy
end
