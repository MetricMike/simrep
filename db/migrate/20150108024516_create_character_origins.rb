class CreateCharacterOrigins < ActiveRecord::Migration
  def change
    create_table :character_origins do |t|
      t.references :character, index: true
      t.references :origin, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_origins, :characters
    add_foreign_key :character_origins, :origins
  end
end
