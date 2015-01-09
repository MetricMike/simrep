class CreateCharacterEvents < ActiveRecord::Migration
  def change
    create_table :character_events do |t|
      t.references :character, index: true
      t.references :event, index: true
      t.boolean :paid
      t.boolean :cleaned

      t.timestamps null: false
    end
    add_foreign_key :character_events, :characters
    add_foreign_key :character_events, :events
  end
end
