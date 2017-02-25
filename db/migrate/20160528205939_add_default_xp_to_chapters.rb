class AddDefaultXpToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :default_xp, :integer, default: 0
  end

  # def better_defaults
  #   Chapter.find_by(name: "Bastion").update(default_xp: 31)
  #   Chapter.find_by(name: "Holurheim").update(default_xp: 71)
  #   # Aquia and Last Rest aren't active yet, so they get NOTHING
  # end
end
