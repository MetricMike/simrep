class CreateCharacterPerks < ActiveRecord::Migration
  def change
    create_table :character_perks do |t|
      t.references :character, index: true
      t.references :perk, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_perks, :characters
    add_foreign_key :character_perks, :perks
  end
end
