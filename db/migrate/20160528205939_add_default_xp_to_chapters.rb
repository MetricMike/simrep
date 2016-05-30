class AddDefaultXpToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :default_xp, :integer, default: 0
    better_defaults
  end

  def better_defaults
    Chapter::BASTION.update(default_xp: 31)
    Chapter::HOLURHEIM.update(default_xp: 71)
    # Aquia and Last Rest aren't active yet, so they get NOTHING
  end
end
