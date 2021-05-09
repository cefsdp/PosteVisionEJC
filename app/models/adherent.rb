class Adherent < ApplicationRecord
  has_many :intervenants, dependent: :destroy
end
