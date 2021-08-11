class Intervenant < ApplicationRecord
  belongs_to :adherent
  belongs_to :phase
  has_one :notation_intervenant, dependent: :destroy
end
