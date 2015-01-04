class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.text :name
      t.integer :experience
      t.references :user, index: true

      t.timestamps
    end
  end
end
