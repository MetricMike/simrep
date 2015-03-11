class CreateCharacterProjects < ActiveRecord::Migration
  def change
    create_table :character_projects do |t|
      t.integer :total_tu
      t.references :character, index: true
      t.references :project, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_projects, :characters
    add_foreign_key :character_projects, :projects
  end
end
