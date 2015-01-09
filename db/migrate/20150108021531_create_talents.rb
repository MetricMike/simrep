class CreateTalents < ActiveRecord::Migration
  def change
    create_table :talents do |t|
      t.string :group
      t.string :name
      t.integer :value
      t.boolean :spec
      t.references :character, index: true

      t.timestamps null: false
    end
  end
end
