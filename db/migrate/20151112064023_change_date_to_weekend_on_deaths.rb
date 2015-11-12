class ChangeDateToWeekendOnDeaths < ActiveRecord::Migration
  def change
    rename_column :deaths, :date, :weekend
  end
end
