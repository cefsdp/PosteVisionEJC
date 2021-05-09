class Etude < ApplicationRecord
  has_many :phases, dependent: :destroy
  has_many :intervenants, through: :phases
end
