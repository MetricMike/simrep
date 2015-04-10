class AddTalentToProjectContributions < ActiveRecord::Migration
  def change
    add_column :project_contributions, :talent, :string
  end
end
