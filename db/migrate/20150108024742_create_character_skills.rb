class CreateCharacterSkills < ActiveRecord::Migration
  def change
    create_table :character_skills do |t|
      t.references :character, index: true
      t.references :skill, index: true

      t.timestamps null: false
    end
    add_foreign_key :character_skills, :characters
    add_foreign_key :character_skills, :skills
  end
end
