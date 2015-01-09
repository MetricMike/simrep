class CreatePerks < ActiveRecord::Migration
  def change
    create_table :perks do |t|
      t.string :source
      t.string :name
      t.integer :cost

      t.timestamps null: false
    end
  end
end
