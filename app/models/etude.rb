class Etude < ApplicationRecord
  has_many :phases, dependent: :destroy
end
