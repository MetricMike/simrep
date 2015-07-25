class AddPaymentStatusToNpcShifts < ActiveRecord::Migration
  def change
    add_column :npc_shifts, :money_paid, :boolean, default: false
    add_column :npc_shifts, :time_paid, :boolean, default: false

    reversible do |direction|
      direction.up do
        NpcShift.reset_column_information
        NpcShift.where(money_paid: nil, time_paid: nil).update_all(money_paid: false, time_paid: false)
      end
    end
  end
end