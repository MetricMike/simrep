class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :campaign
      t.date :weekend
      t.integer :play_exp
      t.integer :clean_exp

      t.timestamps null: false
    end
  end
end
