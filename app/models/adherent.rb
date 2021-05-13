class Adherent < ApplicationRecord
  has_many :intervenants, dependent: :destroy

  validates :nom, presence: true, uniqueness: { scope: :prenom }
  validates :num_ba, presence: true, uniqueness: true
end
