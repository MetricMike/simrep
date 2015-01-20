class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string :source
      t.string :name
      t.string :detail

      t.timestamps null: false
    end
  end
end
