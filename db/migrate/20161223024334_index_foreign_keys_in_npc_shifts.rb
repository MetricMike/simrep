class IndexForeignKeysInNpcShifts < ActiveRecord::Migration
  def change
    add_index :npc_shifts, :character_event_id
  end
end
