class AddWillpowerToEvents < ActiveRecord::Migration
  def change
    add_column :events, :base_willpower, :integer
  end
end
