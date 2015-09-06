class AddCraftingPointsToCharacters < ActiveRecord::Migration
  def change
    create_table :crafting_points do |t|
      t.references  :character, index: true
      t.string      :type
      t.integer     :unranked, default: 0
      t.integer     :apprentice, default: 0
      t.integer     :journeyman, default: 0
      t.integer     :master, default: 0
    end

    add_foreign_key :crafting_points, :characters
  end
end