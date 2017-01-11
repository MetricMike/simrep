class CreateCharacterBirthrights < ActiveRecord::Migration[5.0]
  def change
    create_table :character_birthrights do |t|
      t.references :character, index: true
      t.references :birthright, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_birthrights, :characters
    add_foreign_key :character_birthrights, :birthrights
  end
end
