class AddXpPoolsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :std_retirement_xp_pool, :integer
    add_column :users, :leg_retirement_xp_pool, :integer
  end
end
