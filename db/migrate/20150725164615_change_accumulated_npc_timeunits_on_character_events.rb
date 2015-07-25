class ChangeAccumulatedNpcTimeunitsOnCharacterEvents < ActiveRecord::Migration
  def change
    rename_column :character_events, :accumulated_npc_timeunits_totalhours, :accumulated_npc_timeunits
  end
end