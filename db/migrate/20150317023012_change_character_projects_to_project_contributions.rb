class ChangeCharacterProjectsToProjectContributions < ActiveRecord::Migration
  def change
    rename_table :character_projects, :project_contributions

    change_table :project_contributions do |t|
      t.rename :total_tu, :timeunits
      t.text :note
    end
  end
end
