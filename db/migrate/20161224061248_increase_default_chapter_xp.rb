class IncreaseDefaultChapterXp < ActiveRecord::Migration[5.0]
  def change
    change_column_default :chapters, :default_xp, from: 0, to: 31
  end
end
