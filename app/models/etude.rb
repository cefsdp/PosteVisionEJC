class Etude < ApplicationRecord
  has_many :phases, dependent: :destroy
  has_many :intervenants, through: :phases

  validates :references, presence: true, uniqueness: true
  validates :statut, presence: true, uniqueness: true
  validates :type, presence: true, uniqueness: true
  validates :prestation, presence: true, uniqueness: true
  validates :campus, presence: true, uniqueness: true
  validates :provenance, presence: true, uniqueness: true
  validates :date_demande, presence: true, uniqueness: true
end
