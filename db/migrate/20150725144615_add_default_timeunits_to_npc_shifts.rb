class AddDefaultTimeunitsToNpcShifts < ActiveRecord::Migration
  class NpcShift < ApplicationRecord; end

  def up
    change_column_default :npc_shifts, :hours_to_money, 0
    change_column_default :npc_shifts, :hours_to_time, 0
    change_column_default :npc_shifts, :verified, false
    NpcShift.where(hours_to_money: nil, hours_to_time: nil).update_all(verified: false, hours_to_money: 0, hours_to_time: 0)
  end

  def down
    change_column_default :npc_shifts, :hours_to_money, nil
    change_column_default :npc_shifts, :hours_to_time, nil
    change_column_default :npc_shifts, :verified, nil
  end
end