class Etude < ApplicationRecord
  has_many :phases, dependent: :destroy
  has_many :intervenants, through: :phases

  validates :references, presence: true, uniqueness: true
  validates :statut, presence: true
  validates :type_client, presence: true
  validates :prestation, presence: true
  validates :campus, presence: true
  validates :provenance, presence: true
  validates :date_demande, presence: true
end
