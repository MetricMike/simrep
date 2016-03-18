class CreateTemporaryEffects < ActiveRecord::Migration
  def change
    create_table :temporary_effects do |t|
      t.references :character, index: true, foreign_key: true
      t.string :attr
      t.integer :modifier
      t.datetime :expiration

      t.timestamps null: false
    end
  end
end
