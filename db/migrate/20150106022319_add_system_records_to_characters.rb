class AddSystemRecordsToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :backgrounds, :text
    add_column :characters, :origins, :text
    add_column :characters, :skills, :text
    add_column :characters, :perks, :text
    add_column :characters, :talents, :text
  end
end
