class AddDefaultXpToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :default_xp, :integer, default: 0

    reversible do |dir|
      dir.up do
        Chapter::BASTION.update(default_xp: 31)
        Chapter::HOLURHEIM.update(default_xp: 71)
        # Aquia and Last Rest aren't active yet, so they get NOTHING
      end
    end
  end
end
