class ChangeTemporaryEffectsToSpecialEffects < ActiveRecord::Migration[5.1]
  def change
    rename_table :temporary_effects, :special_effects

    change_table :special_effects do |t|
      t.remove :attr
      t.remove :modifier
      t.string :description
    end
  end
end
