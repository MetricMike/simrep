class AddWeekendIndexOnEvents < ActiveRecord::Migration
  def change
    add_index :events, :weekend
  end
end