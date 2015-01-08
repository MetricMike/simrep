class CreateDeaths < ActiveRecord::Migration
  def change
    create_table :deaths do |t|
      t.text :description
      t.string :physical
      t.string :roleplay
      t.date :date
      t.boolean :perm_chance
      t.references :character, index: true

      t.timestamps null: false
    end
  end
end
