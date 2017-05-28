class AddReviewedAt < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :reviewed_at, :datetime
    add_column :perks, :reviewed_at, :datetime
    add_column :origins, :reviewed_at, :datetime
    add_column :birthrights, :reviewed_at, :datetime
  end
end
