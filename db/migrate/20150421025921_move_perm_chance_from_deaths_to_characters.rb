class MovePermChanceFromDeathsToCharacters < ActiveRecord::Migration
  def change
    remove_column :deaths, :perm_chance, :active

    add_column :characters, :perm_chance, :integer, default: 0
    add_column :characters, :perm_counter, :integer, default: 0
  end
end