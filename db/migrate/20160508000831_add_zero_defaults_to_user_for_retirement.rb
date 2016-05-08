class AddZeroDefaultsToUserForRetirement < ActiveRecord::Migration
  def change
    change_column_default :users, :std_retirement_xp_pool, 0
    change_column_default :users, :leg_retirement_xp_pool, 0
  end
end
