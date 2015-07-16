class AddNpcShiftsToCharacterEvents < ActiveRecord::Migration
  def change
    add_reference :character_events, :npc_shift, foreign_key: true
    add_column :character_events, :accumulated_npc_timeunits_totalhours, :integer
    add_monetize :character_events, :accumulated_npc_money
    add_column :character_events, :awarded, :boolean
  end
end