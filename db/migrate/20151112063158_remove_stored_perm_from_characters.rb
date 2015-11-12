class RemoveStoredPermFromCharacters < ActiveRecord::Migration
  def up
    remove_column :characters, :perm_chance, :integer
    remove_column :characters, :perm_counter, :integer
  end

  def down
    add_column :characters, :perm_chance, :integer, default: 0
    add_column :characters, :perm_counter, :integer, default: 0
  end
end
