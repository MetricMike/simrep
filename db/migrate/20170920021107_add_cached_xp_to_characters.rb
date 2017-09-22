class AddCachedXpToCharacters < ActiveRecord::Migration[5.1]
  def change
    add_column :characters, :cached_experience, :integer

    Character.find_each do |char|
        char.update_cached_xp
        char.save
    end
  end
end
