class Etude < ApplicationRecord
  has_many :phases, class_name: "phases", foreign_key: "reference_id"
end
