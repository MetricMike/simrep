class AdjustAttributesOnNpcShifts < ActiveRecord::Migration
  def change
    remove_column :npc_shifts, :hours_to_money
    remove_column :npc_shifts, :hours_to_time
    remove_column :npc_shifts, :hours_to_verified
    remove_column :npc_shifts, :money_paid
    remove_column :npc_shifts, :time_paid

    add_monetize :npc_shifts, :real_pay
  end
end
