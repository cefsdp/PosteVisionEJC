class Intervenant < ApplicationRecord
  belongs_to :adherent
  belongs_to :phase
end
