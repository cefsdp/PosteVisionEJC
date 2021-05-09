class CreateIntervenants < ActiveRecord::Migration[6.1]
  def change
    create_table :intervenants do |t|
      t.references :adherent, null: false, foreign_key: true
      t.references :phase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
