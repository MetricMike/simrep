class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :source
      t.string :name
      t.integer :cost

      t.timestamps null: false
    end
  end
end
