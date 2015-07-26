class RemoveNpcShiftsFromCharacterEvents < ActiveRecord::Migration
  def up
    remove_reference :character_events, :npc_shift, foreign_key: true
  end

  def down
    add_reference :character_events, :npc_shift, foreign_key: true
  end
end