class AddDefaultTimeunitsToCharacterEvents < ActiveRecord::Migration
  class CharacterEvent < ApplicationRecord; end

  def up
    change_column_default :character_events, :accumulated_npc_timeunits_totalhours, 0
    CharacterEvent.where(accumulated_npc_timeunits_totalhours: nil).update_all(accumulated_npc_timeunits_totalhours: 0)
  end

  def down
    change_column_default :character_events, :accumulated_npc_timeunits_totalhours, nil
  end
end