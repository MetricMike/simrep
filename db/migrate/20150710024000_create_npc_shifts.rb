class CreateNpcShifts < ActiveRecord::Migration
  def change
    create_table :npc_shifts do |t|
      t.references :character_event
      t.datetime :opening
      t.datetime :closing
      t.integer :hours_to_money
      t.integer :hours_to_time
      t.boolean :verified
      t.boolean :dirty, default: false

      t.timestamps null: false
    end

    add_foreign_key :npc_shifts, :character_events
  end
end