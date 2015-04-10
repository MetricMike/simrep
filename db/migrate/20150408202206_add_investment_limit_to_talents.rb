class AddInvestmentLimitToTalents < ActiveRecord::Migration
  def change
    add_column :talents, :investment_limit, :integer, default: 2
  end
end
