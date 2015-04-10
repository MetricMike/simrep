class AddUnusedTalentsToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :unused_talents, :integer, default: 0
  end
end
