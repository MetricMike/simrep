class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.references :leader, index: true

      t.timestamps null: false
    end
    add_foreign_key :projects, :characters, column: :leader
  end
end
