class AddRetiredFlagToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :retired, :boolean
  end
end
