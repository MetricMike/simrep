class AddReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.references :referred_user, references: :users, index: { unique: true }
      t.references :sponsor, references: :users, index: true
      t.references :event_claimed, references: :events, index: true
    end

    add_foreign_key :referrals, :users, column: :sponsor_id
    add_foreign_key :referrals, :users, column: :referred_user_id
    add_foreign_key :referrals, :events, column: :event_claimed_id
  end
end