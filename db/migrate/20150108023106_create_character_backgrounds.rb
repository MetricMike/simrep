class CreateCharacterBackgrounds < ActiveRecord::Migration
  def change
    create_table :character_backgrounds do |t|
      t.references :character, index: true
      t.references :background, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_backgrounds, :characters
    add_foreign_key :character_backgrounds, :backgrounds
  end
end
